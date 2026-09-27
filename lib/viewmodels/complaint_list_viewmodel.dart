import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/drift_database.dart';
import '../providers/repository_providers.dart';

enum ComplaintListFilter { all, pending, overdue, inProgress, resolvedToday }

final complaintListViewModelProvider =
    StateNotifierProvider.family<
      ComplaintListViewModel,
      AsyncValue<List<Complaint>>,
      ComplaintListFilter
    >((ref, filter) => ComplaintListViewModel(ref, filter));

class ComplaintListViewModel
    extends StateNotifier<AsyncValue<List<Complaint>>> {
  final Ref ref;
  final ComplaintListFilter initialFilter;
  String _searchQuery = '';

  ComplaintListViewModel(this.ref, this.initialFilter)
    : super(const AsyncValue.loading()) {
    loadComplaints();
  }

  Future<void> loadComplaints() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(complaintRepositoryProvider);
      List<Complaint> data;

      if (_searchQuery.isNotEmpty) {
        // Search overrides the card filter — searches across everything
        data = await repo.searchComplaints(_searchQuery);
      } else {
        switch (initialFilter) {
          case ComplaintListFilter.all:
            data = await repo.getAllComplaints();
            break;
          case ComplaintListFilter.pending:
            data = await repo.getUnresolvedComplaints();
            break;
          case ComplaintListFilter.overdue:
            data = await repo.getOverdueComplaints();
            break;
          case ComplaintListFilter.inProgress:
            data = await repo.getComplaintsByStatus(ComplaintStatus.inProgress);
            break;
          case ComplaintListFilter.resolvedToday:
            data = await repo.getComplaintsResolvedToday();
            break;
        }
      }

      if (mounted) state = AsyncValue.data(data);
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
    }
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    await loadComplaints();
  }

  Future<void> refresh() => loadComplaints();
}
