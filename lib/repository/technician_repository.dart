import 'package:drift/drift.dart';

import '../database/drift_database.dart';

/// Repository for Technician management
///
/// Handles:
///   - Create, read, update, delete technician records
///   - Track active vs inactive technicians
///   - Get technician workload (how many complaints assigned)
///   - Search technicians
class TechnicianRepository {
  final AppDatabase _db;

  TechnicianRepository(this._db);

  // ============================================================
  // CREATE
  // ============================================================

  /// Add a new technician to the system
  ///
  /// Example:
  ///   tech = await repo.createTechnician(
  ///     name: 'Raj Kumar',
  ///     phone: '9876543210',
  ///     specialty: 'Expert in DVR systems',
  ///   );
  ///   print(tech.id);  // → 1 (auto-generated)
  Future<Technician> createTechnician({
    required String name,
    required String phone,
    String? specialty,
  }) async {
    if (name.trim().isEmpty) {
      throw ArgumentError('Technician name cannot be empty');
    }
    if (phone.trim().isEmpty) {
      throw ArgumentError('Technician phone cannot be empty');
    }

    final existing = await getTechnicianByPhone(phone.trim());
    if (existing != null) {
      return existing;
    }

    final technicianId = await _db.into(_db.technicians).insert(
      TechniciansCompanion(
        name: Value(name.trim()),
        phone: Value(phone.trim()),
        specialty: specialty != null && specialty.isNotEmpty ? Value(specialty) : const Value.absent(),
        active: const Value(true),
      ),
    );

    return (_db.select(_db.technicians)..where((t) => t.id.equals(technicianId))).getSingle();
  }

  // ============================================================
  // READ
  // ============================================================

  /// Get all technicians
  /// Ordered: alphabetically by name
  Future<List<Technician>> getAllTechnicians() async {
    return (_db.select(
      _db.technicians,
    )..orderBy([(t) => OrderingTerm(expression: t.name)])).get();
  }

  /// Get only active technicians
  ///
  /// Example: Owner creates new complaint → dropdown shows only available techs
  Future<List<Technician>> getActiveTechnicians() async {
    return (_db.select(_db.technicians)
          ..where((t) => t.active.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  /// Get only inactive technicians
  ///
  /// Example: Admin view → see terminated/archived technicians
  Future<List<Technician>> getInactiveTechnicians() async {
    return (_db.select(_db.technicians)
          ..where((t) => t.active.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  /// Get a single technician by ID
  /// Returns null if not found
  Future<Technician?> getTechnicianById(int technicianId) async {
    try {
      return await (_db.select(
        _db.technicians,
      )..where((t) => t.id.equals(technicianId))).getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  /// Get technician by phone number
  ///
  /// Example: Owner has tech's phone in contacts, look them up
  Future<Technician?> getTechnicianByPhone(String phone) async {
    try {
      return await (_db.select(
        _db.technicians,
      )..where((t) => t.phone.equals(phone))).getSingleOrNull();
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // UPDATE
  // ============================================================

  /// Update technician details
  ///
  /// Example:
  ///   await repo.updateTechnician(
  ///     technicianId: 2,
  ///     specialty: 'Now also handles IP cameras',
  ///   );
  Future<void> updateTechnician({
    required int technicianId,
    String? name,
    String? phone,
    String? specialty,
  }) async {
    // Verify technician exists
    final technician = await getTechnicianById(technicianId);
    if (technician == null) {
      throw Exception('Technician $technicianId not found');
    }

    // Update only provided fields
    await (_db.update(
      _db.technicians,
    )..where((t) => t.id.equals(technicianId))).write(
      TechniciansCompanion(
        name: name != null ? Value(name) : const Value.absent(),
        phone: phone != null ? Value(phone) : const Value.absent(),
        specialty: specialty != null ? Value(specialty) : const Value.absent(),
      ),
    );
  }

  /// Mark a technician as inactive
  ///
  /// Example: Technician leaves company → mark as inactive (don't delete)
  /// Benefits:
  ///   - Keeps historical records intact (can still see which tech handled what)
  ///   - Prevents assigning new jobs to them
  ///   - Allows reactivation later if they return
  ///
  /// This is better than deleteComplaintsForTechnician() because:
  ///   - Soft delete: data is preserved, marked as inactive
  ///   - Hard delete: permanently removes records (bad for auditing)
  Future<void> deactivateTechnician(int technicianId) async {
    await (_db.update(_db.technicians)..where((t) => t.id.equals(technicianId)))
        .write(const TechniciansCompanion(active: Value(false)));
  }

  /// Mark a technician as active (reactivate)
  ///
  /// Example: Technician returns after leave → reactivate
  Future<void> activateTechnician(int technicianId) async {
    await (_db.update(_db.technicians)..where((t) => t.id.equals(technicianId)))
        .write(const TechniciansCompanion(active: Value(true)));
  }

  // ============================================================
  // DELETE
  // ============================================================

  /// Delete a technician
  ///
  /// Warning: Only do this for technicians with NO complaint history
  /// Consider using deactivateTechnician() instead (soft delete)
  ///
  /// Why? If you delete a tech, and they handled a complaint,
  /// that complaint's foreign key (assignedTechnicianId) becomes orphaned
  Future<void> deleteTechnician(int technicianId) async {
    // Check if technician has any assigned complaints
    final assignedComplaints = await (_db.select(
      _db.complaints,
    )..where((c) => c.assignedTechnicianId.equals(technicianId))).get();

    if (assignedComplaints.isNotEmpty) {
      throw Exception(
        'Cannot delete technician with ${assignedComplaints.length} assigned complaints. '
        'Use deactivateTechnician() instead to preserve history.',
      );
    }

    await (_db.delete(
      _db.technicians,
    )..where((t) => t.id.equals(technicianId))).go();
  }

  // ============================================================
  // SEARCH & FILTER
  // ============================================================

  /// Search technicians by name, phone, or specialty
  ///
  /// Example: Owner types "Raj" → finds "Raj Kumar"
  /// Or types "DVR" → finds techs with "DVR" in specialty
  Future<List<Technician>> searchTechnicians(String query) async {
    if (query.trim().isEmpty) {
      return getAllTechnicians();
    }

    final searchTerm = '%${query.toLowerCase()}%';
    return (_db.select(_db.technicians)
          ..where(
            (t) =>
                t.name.like(searchTerm) |
                t.phone.like(searchTerm) |
                t.specialty.like(searchTerm),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .get();
  }

  // ============================================================
  // WORKLOAD & STATISTICS
  // ============================================================

  /// Get number of complaints assigned to a technician
  ///
  /// Example: "Raj has 5 complaints assigned"
  /// Useful for: Load balancing, seeing who's busy
  Future<int> getAssignedComplaintCount(int technicianId) async {
    return await (_db.select(_db.complaints)
          ..where((c) => c.assignedTechnicianId.equals(technicianId)))
        .get()
        .then((list) => list.length);
  }

  /// Get number of UNRESOLVED complaints for a technician
  ///
  /// Example: "Raj still has 3 pending complaints"
  /// More useful than total count for workload assessment
  Future<int> getUnresolvedComplaintCount(int technicianId) async {
    return await (_db.select(_db.complaints)..where(
          (c) =>
              c.assignedTechnicianId.equals(technicianId) &
              c.status.isNotIn([ComplaintStatus.resolved.name]),
        ))
        .get()
        .then((list) => list.length);
  }

  /// Get technician with least unresolved complaints
  ///
  /// Example: Owner assigns new complaint → suggest least-busy technician
  ///
  /// Returns null if no active technicians
  Future<Technician?> getLeastBusyTechnician() async {
    final activeTechs = await getActiveTechnicians();
    if (activeTechs.isEmpty) return null;

    // Calculate workload for each technician
    final Map<int, int> workloadByTech = {};
    for (final tech in activeTechs) {
      final count = await getUnresolvedComplaintCount(tech.id);
      workloadByTech[tech.id] = count;
    }

    // Find the one with minimum workload
    final leastBusyId = workloadByTech.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    return getTechnicianById(leastBusyId);
  }

  /// Get technician with most unresolved complaints
  ///
  /// Example: Dashboard → "Who needs help?"
  Future<Technician?> getMostBusyTechnician() async {
    final activeTechs = await getActiveTechnicians();
    if (activeTechs.isEmpty) return null;

    // Calculate workload for each technician
    final Map<int, int> workloadByTech = {};
    for (final tech in activeTechs) {
      final count = await getUnresolvedComplaintCount(tech.id);
      workloadByTech[tech.id] = count;
    }

    // Find the one with maximum workload
    final mostBusyId = workloadByTech.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return getTechnicianById(mostBusyId);
  }

  /// Get all technicians with their workload
  ///
  /// Returns: List of maps with technician data + complaintCount
  ///
  /// Example: Admin view → see workload distribution
  Future<List<Map<String, dynamic>>> getTechniciansWithWorkload() async {
    final technicians = await getAllTechnicians();
    final result = <Map<String, dynamic>>[];

    for (final tech in technicians) {
      final complaintCount = await getUnresolvedComplaintCount(tech.id);
      result.add({'technician': tech, 'unresolved_complaints': complaintCount});
    }

    // Sort by complaint count (most busy first)
    result.sort(
      (a, b) => (b['unresolved_complaints'] as int).compareTo(
        a['unresolved_complaints'] as int,
      ),
    );

    return result;
  }
}

// ============================================================
// EXPLANATION: Soft Delete vs Hard Delete
// ============================================================
//
// Hard Delete (deleteComplaintsForTechnician):
//   Permanently removes the record from database
//   Problem: If a complaint references this technician, link is broken
//   Result: "Who fixed this complaint?" → Unknown (lost history)
//
// Soft Delete (deactivateTechnician):
//   Keeps the record but marks it as inactive
//   Problem: Takes more storage (keep historical records)
//   Result: "Who fixed this complaint?" → Still know (audit trail preserved)
//
// For business apps: ALWAYS use soft delete
// Why? Compliance, auditing, historical reporting
//
// Example workflow:
//   1. Raj leaves company
//   2. await repo.deactivateTechnician(rajId)  // Mark inactive
//   3. New complaints only assigned to getActiveTechnicians()
//   4. But old complaints still show "handled by Raj" (correct!)
//
// ============================================================
