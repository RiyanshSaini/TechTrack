import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/drift_database.dart';
import '../providers/repository_providers.dart';
import '../providers/technician_provider.dart';

final technicianManagerViewModelProvider =
    StateNotifierProvider<
      TechnicianManagerViewModel,
      AsyncValue<List<Technician>>
    >((ref) => TechnicianManagerViewModel(ref));

class TechnicianManagerViewModel
    extends StateNotifier<AsyncValue<List<Technician>>> {
  final Ref ref;

  TechnicianManagerViewModel(this.ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(technicianRepositoryProvider);
      final data = await repo.getAllTechnicians();
      if (mounted) state = AsyncValue.data(data);
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  /// Invalidate every other provider anywhere in the app that reads
  /// technician data, so they refetch fresh from the DB instead of
  /// serving a stale cached list.
  void _invalidateDependents() {
    ref.invalidate(allTechniciansProvider);
    ref.invalidate(activeTechniciansProvider);
    ref.invalidate(inactiveTechniciansProvider);
    ref.invalidate(techniciansWithWorkloadProvider);
    ref.invalidate(leastBusyTechnicianProvider);
    ref.invalidate(mostBusyTechnicianProvider);
  }

  Future<void> addTechnician(
    String name,
    String phone,
    String? specialty,
  ) async {
    final repo = ref.read(technicianRepositoryProvider);
    await repo.createTechnician(name: name, phone: phone, specialty: specialty);
    _invalidateDependents();
    if (mounted) await load();
  }

  Future<void> deactivate(int id) async {
    final repo = ref.read(technicianRepositoryProvider);
    await repo.deactivateTechnician(id);
    _invalidateDependents();
    if (mounted) await load();
  }

  Future<void> activate(int id) async {
    final repo = ref.read(technicianRepositoryProvider);
    await repo.activateTechnician(id);
    _invalidateDependents();
    if (mounted) await load();
  }
}
