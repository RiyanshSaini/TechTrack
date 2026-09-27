import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/drift_database.dart';
import 'repository_providers.dart';

// ============================================================
// ASYNC DATA PROVIDERS
// ============================================================

/// Get all technicians
final allTechniciansProvider = FutureProvider<List<Technician>>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getAllTechnicians();
});

/// Get only active technicians
///
/// Used by: Assignment dropdown (only show available techs)
final activeTechniciansProvider = FutureProvider<List<Technician>>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getActiveTechnicians();
});

/// Get inactive technicians
///
/// Used by: Admin/archive view
final inactiveTechniciansProvider =
FutureProvider<List<Technician>>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getInactiveTechnicians();
});

/// Get single technician by ID
final technicianByIdProvider =
FutureProvider.family<Technician?, int>(
      (ref, technicianId) async {
    final repo = ref.watch(technicianRepositoryProvider);
    return repo.getTechnicianById(technicianId);
  },
);

// ============================================================
// SEARCH PROVIDERS
// ============================================================

/// Search technicians
final technicianSearchProvider =
FutureProvider.family<List<Technician>, String>(
      (ref, query) async {
    final repo = ref.watch(technicianRepositoryProvider);
    return repo.searchTechnicians(query);
  },
);

// ============================================================
// WORKLOAD PROVIDERS
// ============================================================

/// Get all technicians with their workload
///
/// Returns: List of {technician, unresolved_complaints}
/// Used by: Admin dashboard showing workload distribution
final techniciansWithWorkloadProvider =
FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getTechniciansWithWorkload();
});

/// Least busy technician
///
/// Used by: Auto-suggest next technician for assignment
final leastBusyTechnicianProvider =
FutureProvider<Technician?>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getLeastBusyTechnician();
});

/// Most busy technician
///
/// Used by: Dashboard alert "Tech needs help"
final mostBusyTechnicianProvider =
FutureProvider<Technician?>((ref) async {
  final repo = ref.watch(technicianRepositoryProvider);
  return repo.getMostBusyTechnician();
});

/// Unresolved complaint count for a technician
final unressolvedCountForTechProvider =
FutureProvider.family<int, int>(
      (ref, technicianId) async {
    final repo = ref.watch(technicianRepositoryProvider);
    return repo.getUnresolvedComplaintCount(technicianId);
  },
);

// ============================================================
// STATEFUL PROVIDERS
// ============================================================

/// Currently selected technician
final selectedTechnicianProvider =
StateNotifierProvider<SelectedTechnicianNotifier, Technician?>(
      (ref) => SelectedTechnicianNotifier(null),
);

class SelectedTechnicianNotifier extends StateNotifier<Technician?> {
  SelectedTechnicianNotifier(super.state);

  void select(Technician technician) {
    state = technician;
  }

  void clear() {
    state = null;
  }
}