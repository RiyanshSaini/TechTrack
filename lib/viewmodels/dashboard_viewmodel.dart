import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/drift_database.dart';
import '../providers/repository_providers.dart';

final dashboardViewModelProvider =
    StateNotifierProvider<DashboardViewModel, AsyncValue<DashboardState>>(
      (ref) => DashboardViewModel(ref),
    );

class DashboardState {
  final int pendingCount;
  final int inProgressCount;
  final int overdueCount;
  final int resolvedTodayCount;
  final List<Complaint> oldestUnresolved;

  DashboardState({
    required this.pendingCount,
    required this.inProgressCount,
    required this.overdueCount,
    required this.resolvedTodayCount,
    required this.oldestUnresolved,
  });
}

class DashboardViewModel extends StateNotifier<AsyncValue<DashboardState>> {
  final Ref ref;

  DashboardViewModel(this.ref) : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(complaintRepositoryProvider);

      final newC = await repo.getComplaintsByStatus(ComplaintStatus.newStatus);
      final assigned = await repo.getComplaintsByStatus(
        ComplaintStatus.assigned,
      );
      final inProgress = await repo.getComplaintsByStatus(
        ComplaintStatus.inProgress,
      );
      final overdue = await repo.getOverdueComplaints();
      final resolved = await repo.getComplaintsByStatus(
        ComplaintStatus.resolved,
      );

      final today = DateTime.now();
      final resolvedToday = resolved.where((c) {
        if (c.resolvedAt == null) return false;
        return c.resolvedAt!.year == today.year &&
            c.resolvedAt!.month == today.month &&
            c.resolvedAt!.day == today.day;
      }).length;

      final unresolved = [...newC, ...assigned, ...inProgress]
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      state = AsyncValue.data(
        DashboardState(
          pendingCount: newC.length + assigned.length,
          inProgressCount: inProgress.length,
          overdueCount: overdue.length,
          resolvedTodayCount: resolvedToday,
          oldestUnresolved: unresolved.take(5).toList(),
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() => load();
}
