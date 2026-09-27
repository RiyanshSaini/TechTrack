import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/drift_database.dart';
import '../providers/complaint_provider.dart';
import '../providers/repository_providers.dart';
import '../services/notification_service.dart';
import 'complaint_list_viewmodel.dart';
import 'dashboard_viewmodel.dart';

final addComplaintViewModelProvider =
StateNotifierProvider<AddComplaintViewModel, AsyncValue<void>>(
      (ref) => AddComplaintViewModel(ref),
);

class AddComplaintViewModel extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  AddComplaintViewModel(this.ref) : super(const AsyncValue.data(null));

  Future<bool> submit({
    required String title,
    required String description,
    required int customerId,
    required Priority priority,
    DateTime? dueBy,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(complaintRepositoryProvider);
      final complaint = await repo.createComplaint(
        title: title,
        description: description,
        customerId: customerId,
        priority: priority,
        dueBy: dueBy,
      );

      if (dueBy != null) {
        await NotificationService.instance.scheduleDueReminder(
          complaintId: complaint.id,
          complaintTitle: title,
          dueBy: dueBy,
        );
      }

      ref.invalidate(allComplaintsProvider);
      ref.invalidate(unresolvedComplaintsProvider);
      ref.invalidate(overdueComplaintsProvider);
      ref.invalidate(complaintListViewModelProvider);
      ref.read(dashboardViewModelProvider.notifier).refresh();

      if (mounted) state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      return false;
    }
  }
}