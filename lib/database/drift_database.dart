import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
part 'drift_database.g.dart';


// ============================================================
// TABLE DEFINITIONS
// ============================================================

/// Customers table
/// Represents a site/customer where CCTV systems are installed
/// Example: "Acme Corp Office, Main Street"
class Customers extends Table {
  /// Primary key — auto-increment unique ID for each customer
  /// Why: Database needs a unique identifier to link complaints to this customer
  IntColumn get id => integer().autoIncrement()();

  /// Customer name or site name
  /// Example: "Acme Corp", "Delhi Office Building 2"
  TextColumn get name => text()();

  /// Phone number for the customer
  /// Why: Need to call them when we have updates
  /// Note: Stored as text (preserves +91, formatting, etc.)
  TextColumn get phone => text()();

  /// Physical location of the CCTV installation
  /// Example: "Sector 5, Chandigarh"
  TextColumn get address => text()();

  /// Notes about this customer/site
  /// Why: Owner might store: "Has 4 cameras", "DVR model XYZ", etc.
  TextColumn get notes => text().nullable()(); // nullable = optional

  /// Timestamp when this customer was added
  /// Why: Useful for reporting ("customers added this month")
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}


/// Technicians table
/// Represents field staff who handle complaints
/// Example: "Raj Kumar", "Priya Singh"
class Technicians extends Table {
  /// Primary key — unique ID for each technician
  IntColumn get id => integer().autoIncrement()();

  /// Technician's name
  TextColumn get name => text()();

  /// Technician's phone number
  /// Why: Owner calls them to assign jobs, or customer calls them directly
  TextColumn get phone => text()();

  /// Notes about this technician's skills
  /// Example: "Good with DVR systems", "Expert in IP cameras"
  /// Why: Owner remembers which tech to assign based on the issue type
  TextColumn get specialty => text().nullable()();

  /// Is this technician currently available?
  /// Example: active=true (available), active=false (terminated, archived)
  /// Why: Owner might want to keep terminated techs in history but not assign new jobs
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  /// When was this technician added to the system
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ============================================================
// EXPLANATION: BoolColumn & withDefault
// ============================================================
//
// BoolColumn:
//   Stores true/false. In SQL: BOOLEAN or INTEGER (0 or 1)
//
// .withDefault(const Constant(true)):
//   If owner creates a technician without specifying "active",
//   it defaults to true (assumed available until marked inactive)
//
// Example:
//   await db.into(db.technicians).insert(
//     TechniciansCompanion(name: Value('Raj'), phone: Value('9876543210'))
//   );
//   // active is automatically set to true!
//
// ============================================================

// ============================================================
// EXPLANATION: Table Structure vs SQL
// ============================================================
//
// What you wrote above (Dart):
//   class Customers extends Table {
//     IntColumn get id => integer().autoIncrement()();
//   }
//
// Drift generates this SQL automatically:
//   CREATE TABLE customers (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     ...
//   );
//
//
// ============================================================

/// Priority levels for complaints
/// Enum: guarantees only valid values exist in database
enum Priority { low, normal, urgent }

/// Status workflow for a complaint
/// Lifecycle: New → Assigned → In Progress → Resolved → (optionally Reopened)
enum ComplaintStatus {
  newStatus,      // Just logged, not yet assigned to anyone
  assigned,       // Owner assigned to a technician
  inProgress,     // Technician started work
  resolved,       // Issue fixed
  reopened        // Customer called back — problem not actually fixed
}

/// Complaints table
/// Core table — one record per complaint logged
/// Relationships:
///   - Belongs to 1 Customer
///   - Belongs to 1 Technician (nullable — might be unassigned)
///   - Has many ComplaintNotes (activity timeline)
class Complaints extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Title/summary of the complaint
  /// Example: "Camera 2 not recording", "DVR keeps rebooting"
  /// Why: Owner needs a quick glance at what the issue is
  /// Length: Keep to ~60 chars so it fits on screen
  TextColumn get title => text()();

  /// Full description of the complaint
  /// Example: "Camera 2 (front entrance) stopped recording at 2 PM today.
  /// Customer says it was working yesterday. No visible damage to camera."
  TextColumn get description => text()();

  /// Priority level
  /// Low: "Nice to fix soon, no rush"
  /// Normal: "Standard issue, routine fix"
  /// Urgent: "System down, critical business impact"
  /// Why: Owner/technician prioritizes work
  /// Type: TEXT (Drift stores enums as strings)
  TextColumn get priority => textEnum<Priority>().withDefault(const Constant('normal'))();

  /// Current status in the workflow
  /// Type: TEXT (Drift stores enums as strings)
  TextColumn get status => textEnum<ComplaintStatus>().withDefault(const Constant('newStatus'))();

  /// Foreign key: Which customer is this complaint about?
  /// Why: Link complaint to customer to see all their complaints
  /// Example: customerId=5 → links to Customers.id=5
  /// .references(): tells Drift this is a foreign key constraint
  IntColumn get customerId => integer().references(Customers, #id)();

  /// Foreign key: Which technician is assigned? (Can be null = unassigned)
  /// Why: Owner assigns work, technician sees their jobs
  /// nullable: a complaint can exist without assignment
  IntColumn get assignedTechnicianId => integer()
      .references(Technicians, #id)
      .nullable()();

  /// When was this complaint logged?
  /// Example: "Aug 17, 2026 at 3:45 PM"
  /// Why: Helps identify oldest unresolved complaints
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Target resolution time (optional)
  /// Example: Owner says "Fix by tomorrow 5 PM"
  /// Why: Drives overdue notifications
  /// nullable: no deadline if owner doesn't set one
  DateTimeColumn get dueBy => dateTime().nullable()();

  /// When was this complaint marked resolved?
  /// Example: "Aug 17, 2026 at 5:30 PM"
  /// nullable: only has a value if status='resolved' or 'reopened'
  /// Why: Track average resolution time, SLA reporting
  DateTimeColumn get resolvedAt => dateTime().nullable()();

  /// Photo URI(s) attached to this complaint
  /// Example: "file:///storage/emulated/.../complaint_123_photo1.jpg"
  /// Why: Visual proof of issue (broken camera, torn wiring, etc.)
  /// nullable: not all complaints have photos
  /// Stored as JSON array: ["photo1.jpg", "photo2.jpg"]
  TextColumn get photoUris => text().nullable()();
}

// ============================================================
// EXPLANATION: Foreign Keys & References
// ============================================================
//
// Line:
//   IntColumn get customerId => integer().references(Customers, #id)();
//
// What it means:
//   customerId is an integer column that MUST match an existing Customers.id
//
// Why?
//   Ensures data integrity: you can't create a complaint linked to
//   customer_id=999 if no customer with id=999 exists
//
// Example flow:
//   1. Create customer: INSERT INTO customers (name, phone) VALUES ('Acme', '...')
//      → gets id=5
//   2. Create complaint: INSERT INTO complaints (title, customerId) VALUES ('...', 5)
//      → Allowed! customer 5 exists
//   3. Try to create complaint with customerId=999
//      → REJECTED! Database enforces the constraint
//
// Foreign keys prevent "orphaned" records (complaints without customers)
//
// ============================================================
//
// ============================================================
// EXPLANATION: Enums (Priority & ComplaintStatus)
// ============================================================
//
// Instead of storing status as loose text:
//   status = 'new' or 'NEW' or 'New' (inconsistent!)
//
// Enums guarantee only valid values:
//   enum ComplaintStatus { newStatus, assigned, inProgress, resolved, reopened }
//
//   db.into(db.complaints).insert(...status: Value(ComplaintStatus.newStatus))
//   // Compiler ensures only these 5 values are allowed
//
// Drift stores enums as TEXT in database:
//   "newStatus", "assigned", "inProgress", etc.
//
// But in Dart, they're type-safe:
//   complaint.status == ComplaintStatus.newStatus
//   complaint.status == 'newStatus'
//
// ============================================================

/// ComplaintNotes table
/// Represents the activity timeline/history of a complaint
/// Example: "Technician Raj called customer to reschedule"
///          "Customer confirmed issue resolved"
///          "Reopened: problem still exists"
///
/// Why separate table?
///   - Complaint can have 0-50+ notes
///   - Storing notes in Complaint (as a JSON string) gets messy
///   - Separate table keeps data normalized (cleaner, easier to query)
///   - Can fetch complaint without notes for fast listing, fetch notes only when viewing detail
class ComplaintNotes extends Table {
  /// Primary key
  IntColumn get id => integer().autoIncrement()();

  /// Which complaint does this note belong to?
  /// Foreign key: must reference existing Complaints.id
  IntColumn get complaintId => integer().references(Complaints, #id)();

  /// The note text
  /// Example: "Called customer, confirmed camera is still broken. Technician will visit Friday 10 AM"
  /// Why: Chronological record of what happened
  TextColumn get textNote => text()();

  /// When was this note created?
  /// Example: "Aug 17, 2026 at 4:15 PM"
  /// Why: Activity timeline is meaningless without timestamps
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// ============================================================
// EXPLANATION: Why ComplaintNotes is Separate
// ============================================================
//
// BAD DESIGN (all in Complaints):
//   class Complaints extends Table {
//     IntColumn get id => ...;
//     TextColumn get title => ...;
//     TextColumn get notesJson => text().nullable()(); //
//   }
//
//   Problem:
//     - Fetching 1000 complaints means downloading 1000 * (500 chars of notes) = huge
//     - If one note corrupts the JSON, entire complaint breaks
//     - Hard to query "all notes from today"
//
// GOOD DESIGN (separate table):
//   class Complaints extends Table { ... }
//   class ComplaintNotes extends Table {
//     IntColumn get complaintId => ...;
//     TextColumn get text => ...;
//   }
//
//   Advantages:
//     - Fetch complaint list without notes (fast)
//     - Fetch notes only when viewing complaint detail (lazy loading)
//     - Can query "all notes from today" directly
//     - One bad note doesn't corrupt the complaint record
//
// Database pattern: This is called "Normalization"
// Reduces data duplication, improves performance, ensures consistency
//
// ============================================================

/// Main Drift database class
/// This class connects all tables and provides query methods
/// Think of it as the "database manager" that orchestrates everything
@DriftDatabase(tables: [Customers, Technicians, Complaints, ComplaintNotes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1; // Schema version = 1 (first version, no migrations yet)

  // ============================================================
  // HELPER METHODS (Optional but useful)
  // ============================================================

  /// Get all complaints for a specific customer
  /// Why: Owner clicks customer → see all their past/current complaints
  Future<List<Complaint>> getComplaintsForCustomer(int customerId) {
    return (select(complaints)..where((c) => c.customerId.equals(customerId)))
        .get();
  }

  /// Get all unresolved complaints
  /// Why: Dashboard needs to show pending items
  Future<List<Complaint>> getUnresolvedComplaints() {
    return (select(complaints)
      ..where((c) => c.status.isNotIn([
        ComplaintStatus.resolved.name,
        ComplaintStatus.reopened.name
      ])))
        .get();
  }

  /// Get overdue complaints (past dueBy date)
  /// Why: Reminders, prioritization
  Future<List<Complaint>> getOverdueComplaints() {
    return (select(complaints)
      ..where((c) =>
      c.dueBy.isSmallerThanValue(DateTime.now()) &
      c.status.equals(ComplaintStatus.resolved.name).not())
    )
        .get();
  }

  /// Get all notes for a complaint, ordered by newest first
  /// Why: View complaint detail → show activity timeline
  Future<List<ComplaintNote>> getNotesForComplaint(int complaintId) {
    return (select(complaintNotes)
      ..where((n) => n.complaintId.equals(complaintId))
      ..orderBy([(n) => OrderingTerm(expression: n.createdAt, mode: OrderingMode.desc)]))
        .get();
  }

  /// Search complaints by customer name or phone
  /// Why: Owner types "Acme" → finds all complaints from Acme
  Future<List<Complaint>> searchComplaints(String query) async {
    final matchingCustomers = await (select(customers)
      ..where((c) =>
      c.name.like('%$query%') | c.phone.like('%$query%')))
        .get();

    final customerIds = matchingCustomers.map((c) => c.id).toList();

    if (customerIds.isEmpty) return [];

    return (select(complaints)
      ..where((c) => c.customerId.isIn(customerIds)))
        .get();
  }
}

// ============================================================
// EXPLANATION: @DriftDatabase Annotation
// ============================================================
//
// @DriftDatabase(tables: [Customers, Technicians, Complaints, ComplaintNotes])
//
// Tells Drift:
//   "Create a database with these 4 tables"
//
// Drift then generates:
//   1. CREATE TABLE statements for each table
//   2. Query methods: select(), insert(), update(), delete()
//   3. Auto-migrates schema if you change tables
//
// _$AppDatabase:
//   This is the generated base class (created by build_runner)
//   You extend it and provide schemaVersion + connections
//
// ============================================================
//
// ============================================================
// EXPLANATION: schemaVersion
// ============================================================
//
// schemaVersion: int = version of your database schema
//
// Scenario:
//   v1: Database has Customers, Technicians, Complaints
//
//   Later, you add a new field:
//   class Customers {
//     TextColumn get email => text()(); // NEW FIELD
//   }
//
//   You increment: schemaVersion => 2
//
//   Drift detects the change and auto-runs migrations.
//   Existing users don't lose data — new column is added to their DB.
//
// For now: schemaVersion = 1 (initial release, no changes)
//
// ============================================================

// ============================================================
// DATABASE CONNECTION
// ============================================================

/// Opens the SQLite database file
/// Why a separate function?
///   Drift needs to know WHERE to store the database file
///   On iOS: /Documents/app_documents/
///   On Android: /data/data/com.techtrack/
///
/// This function returns a LazyDatabase which opens the connection lazily
/// (only when first query runs, not at app startup)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/techtrack.db');

    if (Platform.isIOS) {
      // On iOS, ensure database folder exists
      await dbFolder.create(recursive: true);
    }

    return NativeDatabase(file);
  });
}

// ============================================================
// EXPLANATION: LazyDatabase & NativeDatabase
// ============================================================
//
// LazyDatabase:
//   Delays database opening until first use
//   Why? Faster app startup time (don't wait for DB if not used)
//
// NativeDatabase:
//   Uses SQLite native library for this platform
//   On iOS: Uses iOS's built-in SQLite
//   On Android: Uses Android's built-in SQLite
//   (Drift abstracts both away — one code, works on both)
//
// getApplicationDocumentsDirectory():
//   Returns app's private documents folder
//   Example on iOS: /var/mobile/Containers/Data/Documents/com.techtrack/
//   Example on Android: /data/data/com.techtrack/app_documents/
//
// Why private folder?
//   - Other apps can't access this data (privacy)
//   - Data survives app updates
//   - Data deleted when app uninstalled (clean)
//
// ============================================================