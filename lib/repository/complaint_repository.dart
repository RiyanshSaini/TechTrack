import 'package:drift/drift.dart';

import '../database/drift_database.dart';

/// Repository for Complaint CRUD operations
///
/// Sits between the UI/ViewModels and the Database
/// Handles:
///   - Creating, reading, updating complaints
///   - Filtering (by status, technician, customer)
///   - Validations before saving
///   - Related data loading (customer, technician details)
class ComplaintRepository {
  final AppDatabase _db;

  ComplaintRepository(this._db);

  // ============================================================
  // CREATE
  // ============================================================

  /// Create a new complaint
  ///
  /// Input: [title], [description], [customerId], [priority]
  /// Returns: Created Complaint object with generated ID
  ///
  /// Example:
  ///   complaint = await repo.createComplaint(
  ///     title: 'Camera 2 down',
  ///     description: 'Not recording',
  ///     customerId: 5,
  ///     priority: Priority.urgent,
  ///   );
  ///   print(complaint.id);  // → 42 (auto-generated)
  Future<Complaint> createComplaint({
    required String title,
    required String description,
    required int customerId,
    required Priority priority,
    DateTime? dueBy,
  }) async {
    // Validate input
    if (title.trim().isEmpty) {
      throw ArgumentError('Complaint title cannot be empty');
    }
    if (description.trim().isEmpty) {
      throw ArgumentError('Complaint description cannot be empty');
    }

    // Create complaint record
    // ComplaintsCompanion: Drift's helper class for partial data
    // (you don't need to provide id or createdAt — they auto-fill)
    final complaintId = await _db
        .into(_db.complaints)
        .insert(
          ComplaintsCompanion(
            title: Value(title),
            description: Value(description),
            customerId: Value(customerId),
            priority: Value(priority),
            status: Value(ComplaintStatus.newStatus),
            dueBy: dueBy != null ? Value(dueBy) : const Value.absent(),
          ),
        );

    // Fetch and return the created complaint
    return (_db.select(_db.complaints)..where((c) => c.id.equals(complaintId))).getSingle();
  }

  // ============================================================
  // READ
  // ============================================================

  /// Get all complaints
  /// Ordered: newest first
  Future<List<Complaint>> getAllComplaints() async {
    return (_db.select(_db.complaints)..orderBy([
          (c) => OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  /// Get a single complaint by ID
  ///
  /// Returns null if not found
  Future<Complaint?> getComplaintById(int complaintId) async {
    try {
      return await (_db.select(
        _db.complaints,
      )..where((c) => c.id.equals(complaintId))).getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Get complaints for a specific customer
  ///
  /// Example: User clicks on "Acme Corp" → show all their complaints
  Future<List<Complaint>> getComplaintsForCustomer(int customerId) async {
    return (_db.select(_db.complaints)
          ..where((c) => c.customerId.equals(customerId))
          ..orderBy([
            (c) =>
                OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get complaints resolved today
  /// Used by: Dashboard "Resolved Today" card
  Future<List<Complaint>> getComplaintsResolvedToday() async {
    final all = await getComplaintsByStatus(ComplaintStatus.resolved);
    final now = DateTime.now();
    return all.where((c) {
      if (c.resolvedAt == null) return false;
      return c.resolvedAt!.year == now.year &&
          c.resolvedAt!.month == now.month &&
          c.resolvedAt!.day == now.day;
    }).toList();
  }

  /// Get complaints assigned to a specific technician
  ///
  /// Example: Dashboard → "What's Raj assigned to?"
  Future<List<Complaint>> getComplaintsForTechnician(int technicianId) async {
    return (_db.select(_db.complaints)
          ..where((c) => c.assignedTechnicianId.equals(technicianId))
          ..orderBy([
            (c) =>
                OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get all unresolved complaints
  ///
  /// Example: Dashboard → "How many complaints pending?"
  Future<List<Complaint>> getUnresolvedComplaints() async {
    return (_db.select(_db.complaints)
          ..where((c) => c.status.isNotIn([ComplaintStatus.resolved.name]))
          ..orderBy([
            (c) =>
                OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get overdue complaints (past dueBy date)
  ///
  /// Example: Reminders → "Which complaints are overdue?"
  Future<List<Complaint>> getOverdueComplaints() async {
    final now = DateTime.now();
    return (_db.select(_db.complaints)
          ..where(
            (c) =>
                c.dueBy.isSmallerThanValue(now) &
                c.status.equals(ComplaintStatus.resolved.name).not(),
          )
          ..orderBy([
            (c) => OrderingTerm(expression: c.dueBy, mode: OrderingMode.asc),
          ]))
        .get();
  }

  // ============================================================
  // UPDATE
  // ============================================================

  /// Update complaint status
  ///
  /// Example:
  ///   await repo.updateComplaintStatus(42, ComplaintStatus.resolved);
  ///   → status changes, resolvedAt timestamp is auto-set
  Future<void> updateComplaintStatus(
    int complaintId,
    ComplaintStatus newStatus,
  ) async {
    final complaint = await getComplaintById(complaintId);
    if (complaint == null) {
      throw Exception('Complaint $complaintId not found');
    }

    // If resolving, set resolvedAt timestamp
    DateTime? resolvedAt;
    if (newStatus == ComplaintStatus.resolved) {
      resolvedAt = DateTime.now();
    }
    // If reopening, clear resolvedAt (back to "open")
    if (newStatus == ComplaintStatus.reopened) {
      resolvedAt = null;
    }

    await (_db.update(
      _db.complaints,
    )..where((c) => c.id.equals(complaintId))).write(
      ComplaintsCompanion(
        status: Value(newStatus),
        resolvedAt: resolvedAt != null
            ? Value(resolvedAt)
            : const Value.absent(),
      ),
    );
  }

  /// Assign complaint to a technician
  ///
  /// Example:
  ///   await repo.assignToTechnician(42, 5);
  ///   → Complaint 42 now assigned to Technician 5
  ///   → Status changed to "assigned"
  Future<void> assignToTechnician(int complaintId, int technicianId) async {
    await (_db.update(
      _db.complaints,
    )..where((c) => c.id.equals(complaintId))).write(
      ComplaintsCompanion(
        assignedTechnicianId: Value(technicianId),
        status: Value(ComplaintStatus.assigned),
      ),
    );
  }

  /// Unassign complaint (remove technician)
  ///
  /// Example: Owner realizes Raj is too busy, reassign manually later
  Future<void> unassignTechnician(int complaintId) async {
    await (_db.update(_db.complaints)..where((c) => c.id.equals(complaintId)))
        .write(const ComplaintsCompanion(assignedTechnicianId: Value.absent()));
  }

  /// Update complaint details
  Future<void> updateComplaint({
    required int id,
    String? title,
    String? description,
    Priority? priority,
    DateTime? dueBy,
  }) async {
    await (_db.update(_db.complaints)..where((c) => c.id.equals(id))).write(
      ComplaintsCompanion(
        title: title != null ? Value(title) : const Value.absent(),
        description: description != null
            ? Value(description)
            : const Value.absent(),
        priority: priority != null ? Value(priority) : const Value.absent(),
        dueBy: dueBy != null ? Value(dueBy) : const Value.absent(),
      ),
    );
  }

  // ============================================================
  // DELETE
  // ============================================================

  /// Delete a complaint (hard delete)
  ///
  /// Warning: This is permanent. Consider soft-delete (status='deleted') instead.
  Future<void> deleteComplaint(int complaintId) async {
    await (_db.delete(
      _db.complaints,
    )..where((c) => c.id.equals(complaintId))).go();
  }

  // ============================================================
  // SEARCH & FILTER
  // ============================================================

  /// Search complaints by title or description
  ///
  /// Example: User types "camera" → find all complaints mentioning camera
  Future<List<Complaint>> searchComplaints(String query) async {
    if (query.trim().isEmpty) {
      return getAllComplaints();
    }

    final searchTerm = '%${query.toLowerCase()}%';
    return (_db.select(_db.complaints)..where(
          (c) => c.title.like(searchTerm) | c.description.like(searchTerm),
        ))
        .get();
  }

  /// Get complaints by status
  ///
  /// Example: Dashboard → "Show only urgent complaints"
  Future<List<Complaint>> getComplaintsByStatus(ComplaintStatus status) async {
    return (_db.select(_db.complaints)
          ..where((c) => c.status.equalsValue(status))
          ..orderBy([
            (c) =>
                OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  /// Get complaints by priority
  ///
  /// Example: Filter → "Show only urgent"
  Future<List<Complaint>> getComplaintsByPriority(Priority priority) async {
    return (_db.select(_db.complaints)
          ..where((c) => c.priority.equalsValue(priority))
          ..orderBy([
            (c) =>
                OrderingTerm(expression: c.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }
}

// ============================================================
// EXPLANATION: Value vs Value.absent()
// ============================================================
//
// Drift's ComplaintsCompanion is a helper for partial updates
//
// Value(something):       Include this field in the update
// Value.absent():         Skip this field (don't change it)
//
// Example:
//   ComplaintsCompanion(
//     title: Value('New Title'),           // ✅ Update title
//     description: Value.absent(),         // ❌ Leave description as-is
//   )
//
// Why?
//   You might want to update ONLY the title without touching description
//   Raw SQL would require: UPDATE complaints SET title = '...' WHERE id = ...
//   Drift simplifies this with Value/Value.absent()
//
// ============================================================
