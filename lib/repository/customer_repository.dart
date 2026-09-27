
import 'package:drift/drift.dart';

import '../database/drift_database.dart';

/// Repository for Customer (site) management
///
/// Handles:
///   - Create, read, update, delete customer records
///   - Search customers by name/phone
///   - Get all customers
///   - Track customer history (complaints per customer)
class CustomerRepository {
  final AppDatabase _db;

  CustomerRepository(this._db);

  // ============================================================
  // CREATE
  // ============================================================

  /// Create a new customer/site
  ///
  /// Example:
  ///   customer = await repo.createCustomer(
  ///     name: 'Acme Corp',
  ///     phone: '9876543210',
  ///     address: 'Sector 5, Chandigarh',
  ///     notes: 'Has 4 cameras, DVR model ABC123',
  ///   );
  ///   print(customer.id);  // → 1 (auto-generated)
  Future<Customer> createCustomer({
    required String name,
    required String phone,
    required String address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Customer name cannot be empty');
    }
    if (phone.trim().isEmpty) {
      throw ArgumentError('Customer phone cannot be empty');
    }
    if (address.trim().isEmpty) {
      throw ArgumentError('Customer address cannot be empty');
    }

    final existing = await getCustomerByPhone(phone.trim());
    if (existing != null) {
      return existing;
    }

    final customerId = await _db.into(_db.customers).insert(
      CustomersCompanion(
        name: Value(name.trim()),
        phone: Value(phone.trim()),
        address: Value(address.trim()),
        notes: notes != null && notes.isNotEmpty ? Value(notes) : const Value.absent(),
      ),
    );

    return (_db.select(_db.customers)..where((c) => c.id.equals(customerId))).getSingle();
  }

  // ============================================================
  // READ
  // ============================================================

  /// Get all customers
  /// Ordered: alphabetically by name
  Future<List<Customer>> getAllCustomers() async {
    return (_db.select(_db.customers)
      ..orderBy([(c) => OrderingTerm(expression: c.name)]))
        .get();
  }

  /// Get a single customer by ID
  ///
  /// Returns null if not found
  Future<Customer?> getCustomerById(int customerId) async {
    try {
      return await (_db.select(_db.customers)
        ..where((c) => c.id.equals(customerId)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Get customer with complaint count
  ///
  /// Useful for dashboard: "Customer has 5 pending complaints"
  ///
  /// Returns: Map with customer data + complaintCount
  Future<Map<String, dynamic>?> getCustomerWithStats(int customerId) async {
    final customer = await getCustomerById(customerId);
    if (customer == null) return null;

    final complaintCount = await (_db.select(_db.complaints)
      ..where((c) => c.customerId.equals(customerId)))
        .get()
        .then((list) => list.length);

    return {
      'customer': customer,
      'complaintCount': complaintCount,
    };
  }

  /// Get all active customers (those with complaints)
  ///
  /// Example: Dashboard → "Which sites have open issues?"
  Future<List<Customer>> getActiveCustomers() async {
    final complaintCustomerIds = await (_db.select(_db.complaints)
      ..where((c) => c.status.isNotIn([ComplaintStatus.resolved.name])))
        .get()
        .then((complaints) => complaints.map((c) => c.customerId).toSet());

    if (complaintCustomerIds.isEmpty) return [];

    return (_db.select(_db.customers)
      ..where((c) => c.id.isIn(complaintCustomerIds.toList()))
      ..orderBy([(cust) => OrderingTerm(expression: cust.name)]))
        .get();
  }

  // ============================================================
  // UPDATE
  // ============================================================

  /// Update customer details
  ///
  /// Only updates fields that are provided (others remain unchanged)
  ///
  /// Example:
  ///   await repo.updateCustomer(
  ///     customerId: 5,
  ///     phone: '9999999999',  // Only update phone
  ///   );
  Future<void> updateCustomer({
    required int customerId,
    String? name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    // Verify customer exists
    final customer = await getCustomerById(customerId);
    if (customer == null) {
      throw Exception('Customer $customerId not found');
    }

    // Update only provided fields
    await (_db.update(_db.customers)
      ..where((c) => c.id.equals(customerId)))
        .write(
      CustomersCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        phone: phone != null ? Value(phone) : const Value.absent(),
        address: address != null ? Value(address) : const Value.absent(),
        notes: notes != null ? Value(notes) : const Value.absent(),
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  /// Delete a customer
  ///
  /// Warning: Be careful! Deleting a customer with complaints will break foreign keys
  /// Consider keeping customers even if no active complaints (for historical reference)
  ///
  /// Best practice: Instead of deleting, add an 'active' boolean field to hide archived customers
  Future<void> deleteCustomer(int customerId) async {
    // First check if customer has any complaints
    final complaints = await (_db.select(_db.complaints)
      ..where((c) => c.customerId.equals(customerId)))
        .get();

    if (complaints.isNotEmpty) {
      throw Exception(
          'Cannot delete customer with ${complaints.length} complaints. '
              'Consider archiving instead.');
    }

    await (_db.delete(_db.customers)
      ..where((c) => c.id.equals(customerId)))
        .go();
  }

  // ============================================================
  // SEARCH & FILTER
  // ============================================================

  /// Search customers by name, phone, or address
  ///
  /// Example: Owner types "Acme" → finds "Acme Corp", "Acme Branch 2"
  ///
  /// This is a flexible search:
  ///   - Case-insensitive (LIKE is case-insensitive by default in SQLite)
  ///   - Partial match (typing "Acm" finds "Acme")
  ///   - Searches multiple fields (name, phone, address)
  Future<List<Customer>> searchCustomers(String query) async {
    if (query.trim().isEmpty) {
      return getAllCustomers();
    }

    final searchTerm = '%${query.toLowerCase()}%';
    return (_db.select(_db.customers)
      ..where((c) =>
      c.name.like(searchTerm) |
      c.phone.like(searchTerm) |
      c.address.like(searchTerm))
      ..orderBy([(cust) => OrderingTerm(expression: cust.name)]))
        .get();
  }

  /// Get customers with complaints in a specific status
  ///
  /// Example: "Which customers have URGENT complaints?"
  Future<List<Customer>> getCustomersWithComplaintStatus(
      ComplaintStatus status) async {
    final customerIds = await (_db.select(_db.complaints)
      ..where((c) => c.status.equalsValue(status)))
        .get()
        .then((complaints) => complaints.map((c) => c.customerId).toSet());

    if (customerIds.isEmpty) return [];

    return (_db.select(_db.customers)
      ..where((c) => c.id.isIn(customerIds.toList()))
      ..orderBy([(cust) => OrderingTerm(expression: cust.name)]))
        .get();
  }

  /// Get customer by phone number
  ///
  /// Example: Customer calls → find their record by phone
  /// Returns null if not found (new customer calling)
  Future<Customer?> getCustomerByPhone(String phone) async {
    try {
      return await (_db.select(_db.customers)
        ..where((c) => c.phone.equals(phone)))
          .getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // STATISTICS & REPORTING
  // ============================================================

  /// Get total complaint count for a customer
  ///
  /// Example: "This customer has called 5 times about issues"
  Future<int> getComplaintCountForCustomer(int customerId) async {
    return await (_db.select(_db.complaints)
      ..where((c) => c.customerId.equals(customerId)))
        .get()
        .then((list) => list.length);
  }

  /// Get customer with most unresolved complaints
  ///
  /// Example: Dashboard → "Which site needs most attention?"
  Future<Customer?> getCustomerWithMostIssues() async {
    // Group complaints by customerId, count, order by count descending
    final complaints = await (_db.select(_db.complaints)
      ..where((c) => c.status.isNotIn([ComplaintStatus.resolved.name])))
        .get();

    if (complaints.isEmpty) return null;

    // Map: customerId → count
    final Map<int, int> countByCustomer = {};
    for (final complaint in complaints) {
      countByCustomer[complaint.customerId] =
          (countByCustomer[complaint.customerId] ?? 0) + 1;
    }

    // Get the customer with highest count
    final topCustomerId = countByCustomer.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return getCustomerById(topCustomerId);
  }
}

// ============================================================
// EXPLANATION: Foreign Key Constraints
// ============================================================
//
// When you create a Complaint, you reference customerId:
//   IntColumn get customerId => integer().references(Customers, #id)();
//
// This means:
//   - Every complaint MUST link to an existing customer
//   - You CANNOT delete a customer with complaints
//
// deleteCustomer() checks for this:
//   If complaints exist for this customer → throw error
//   Otherwise → safe to delete
//
// Why?
//   - Prevents orphaned data (complaints with no customer)
//   - Maintains data integrity (can't accidentally lose audit trail)
//   - Encourages keeping historical customers (for reporting)
//
// Best practice:
//   Instead of deleting customers, add an 'active' field:
//   - Mark old customers as inactive
//   - New complaints only created for active customers
//   - But you keep historical data
//
// ============================================================