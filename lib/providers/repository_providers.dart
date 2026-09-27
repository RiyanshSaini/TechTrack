import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/drift_database.dart';
import '../repository/complaint_repository.dart';
import '../repository/customer_repository.dart';
import '../repository/technician_repository.dart';

// ============================================================
// DATABASE PROVIDER
// ============================================================

/// Provides the Drift database instance
///
/// This is a Singleton — Riverpod ensures only one instance exists
/// Why? Database connection should be created once and reused everywhere
///
/// Usage:
///   final db = ref.watch(databaseProvider);
///   await db.into(db.complaints).insert(...);
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// ============================================================
// REPOSITORY PROVIDERS
// ============================================================

/// Provides the ComplaintRepository instance
///
/// Dependencies: Requires databaseProvider
/// Why? Repositories need the database to query/insert data
///
/// Riverpod automatically:
///   1. Creates database via databaseProvider
///   2. Passes it to ComplaintRepository
///   3. Caches the repository (one instance for entire app)
///
/// Usage in other providers:
///   final repo = ref.watch(complaintRepositoryProvider);
///   final complaints = await repo.getAllComplaints();
final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ComplaintRepository(db);
});

/// Provides the CustomerRepository instance
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CustomerRepository(db);
});

/// Provides the TechnicianRepository instance
final technicianRepositoryProvider = Provider<TechnicianRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return TechnicianRepository(db);
});

// ============================================================
// EXPLANATION: Dependency Injection with Providers
// ============================================================
//
// Traditional way (❌ Hard to test):
//   class ComplaintScreen {
//     final db = AppDatabase();  // Hard-coded dependency
//     final repo = ComplaintRepository(db);
//   }
//
// Problem:
//   - Can't test without real database
//   - Dependencies are scattered everywhere
//   - Changes require editing multiple files
//
// Riverpod way (✅ Flexible, testable):
//   final complaintRepositoryProvider = Provider((ref) {
//     final db = ref.watch(databaseProvider);
//     return ComplaintRepository(db);
//   });
//
// Why better?
//   - All dependencies defined in ONE place (this file)
//   - For testing: Just create a FakeRepository, create a FakeProvider
//   - Changes to dependencies: Update ONE place
//   - Riverpod handles creating instances, caching, cleanup
//
// This pattern is called "Dependency Injection"
// Riverpod handles the "injection" automatically
//
// ============================================================