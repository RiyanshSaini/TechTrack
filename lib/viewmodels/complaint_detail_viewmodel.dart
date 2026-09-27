import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/drift_database.dart';
import '../providers/complaint_provider.dart';
import '../providers/repository_providers.dart';
import '../services/notification_service.dart';
import 'complaint_list_viewmodel.dart';
import 'dashboard_viewmodel.dart';

final complaintDetailViewModelProvider =
    StateNotifierProvider.family<
      ComplaintDetailViewModel,
      AsyncValue<ComplaintDetailState>,
      int
    >((ref, complaintId) => ComplaintDetailViewModel(ref, complaintId));

class ComplaintDetailState {
  final Complaint complaint;
  final Customer? customer;
  final Technician? technician;
  final List<ComplaintNote> notes;

  ComplaintDetailState({
    required this.complaint,
    this.customer,
    this.technician,
    required this.notes,
  });
}

class ComplaintDetailViewModel
    extends StateNotifier<AsyncValue<ComplaintDetailState>> {
  final Ref ref;
  final int complaintId;

  ComplaintDetailViewModel(this.ref, this.complaintId)
    : super(const AsyncValue.loading()) {
    load();
  }

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final complaintRepo = ref.read(complaintRepositoryProvider);
      final customerRepo = ref.read(customerRepositoryProvider);
      final techRepo = ref.read(technicianRepositoryProvider);
      final db = ref.read(databaseProvider);

      final complaint = await complaintRepo.getComplaintById(complaintId);
      if (complaint == null) {
        state = AsyncValue.error('Complaint not found', StackTrace.current);
        return;
      }

      final customer = await customerRepo.getCustomerById(complaint.customerId);
      final tech = complaint.assignedTechnicianId != null
          ? await techRepo.getTechnicianById(complaint.assignedTechnicianId!)
          : null;
      final notes = await db.getNotesForComplaint(complaintId);

      state = AsyncValue.data(
        ComplaintDetailState(
          complaint: complaint,
          customer: customer,
          technician: tech,
          notes: notes,
        ),
      );
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateStatus(ComplaintStatus newStatus) async {
    final repo = ref.read(complaintRepositoryProvider);
    await repo.updateComplaintStatus(complaintId, newStatus);

    if (newStatus == ComplaintStatus.resolved) {
      await NotificationService.instance.cancelDueReminder(complaintId);
    }

    _invalidateListsAndDashboard();
    if (mounted) await load();
  }

  Future<void> assignTechnician(int technicianId) async {
    final repo = ref.read(complaintRepositoryProvider);
    await repo.assignToTechnician(complaintId, technicianId);
    _invalidateListsAndDashboard();
    if (mounted) await load();
  }

  Future<void> addNote(String text) async {
    final db = ref.read(databaseProvider);
    await db
        .into(db.complaintNotes)
        .insert(
          ComplaintNotesCompanion(
            complaintId: Value(complaintId),
            textNote: Value(text),
          ),
        );
    await load();
  }
  /// Advance to the next status in the forward workflow.
  /// Only allows moving exactly one step forward from the current status.
  Future<void> advanceStatus() async {
    final current = state.valueOrNull?.complaint.status;
    if (current == null) return;

    ComplaintStatus? next;
    switch (current) {
      case ComplaintStatus.newStatus:
        next = ComplaintStatus.assigned;
        break;
      case ComplaintStatus.assigned:
        next = ComplaintStatus.inProgress;
        break;
      case ComplaintStatus.inProgress:
        next = ComplaintStatus.resolved;
        break;
      case ComplaintStatus.resolved:
      case ComplaintStatus.reopened:
        return; // no forward step from here via this method
    }

    await updateStatus(next);
  }

  /// Reopen a resolved complaint. Separate from advanceStatus because
  /// it's an exception path, not part of the normal forward flow.
  Future<void> reopen() async {
    await updateStatus(ComplaintStatus.reopened);
  }

  void _invalidateListsAndDashboard() {
    ref.invalidate(allComplaintsProvider);
    ref.invalidate(unresolvedComplaintsProvider);
    ref.invalidate(overdueComplaintsProvider);
    ref.invalidate(complaintListViewModelProvider);
    ref.read(dashboardViewModelProvider.notifier).refresh();
  }
}
