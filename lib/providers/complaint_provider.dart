import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/drift_database.dart';
import 'repository_providers.dart';

// ============================================================
// ASYNC DATA PROVIDERS (Fetch from Database)
// ============================================================

/// Get ALL complaints
///
/// Type: FutureProvider<List<Complaint>>
/// What it does:
///   1. Calls repo.getAllComplaints()
///   2. Waits for the Future to complete
///   3. Caches the result
///   4. Returns AsyncValue<List<Complaint>> (contains loading/error/data states)
///
/// Usage in UI:
///   ref.watch(allComplaintsProvider).when(
///     loading: () => CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (complaints) => ListView(children: [...])
///   )
///
/// Auto-refetch when:
///   - A complaint is created/updated/deleted
///   - Screen is refreshed (pull-to-refresh)
final allComplaintsProvider = FutureProvider<List<Complaint>>((ref) async {
  final repo = ref.watch(complaintRepositoryProvider);
  return repo.getAllComplaints();
});

/// Get UNRESOLVED complaints
///
/// Used by: Dashboard (shows pending complaints)
final unresolvedComplaintsProvider =
FutureProvider<List<Complaint>>((ref) async {
  final repo = ref.watch(complaintRepositoryProvider);
  return repo.getUnresolvedComplaints();
});

/// Get OVERDUE complaints
///
/// Used by: Reminders, alerts
final overdueComplaintsProvider = FutureProvider<List<Complaint>>((ref) async {
  final repo = ref.watch(complaintRepositoryProvider);
  return repo.getOverdueComplaints();
});

/// Get complaints for a specific customer
///
/// Takes parameter: customerId
/// Why parameterized? Needed when viewing customer details
///
/// Example:
///   ref.watch(complaintsByCustomerProvider(customerId: 5))
///   → returns only complaints for customer 5
final complaintsByCustomerProvider = FutureProvider.family<List<Complaint>, int>(
      (ref, customerId) async {
    final repo = ref.watch(complaintRepositoryProvider);
    return repo.getComplaintsForCustomer(customerId);
  },
);

/// Get complaints assigned to a specific technician
///
/// Used by: Tech workload view, assignment screens
final complaintsByTechnicianProvider =
FutureProvider.family<List<Complaint>, int>(
      (ref, technicianId) async {
    final repo = ref.watch(complaintRepositoryProvider);
    return repo.getComplaintsForTechnician(technicianId);
  },
);

// ============================================================
// FILTERED/SEARCHED PROVIDERS
// ============================================================

/// Search complaints by status
///
/// Example: Show only "Resolved" complaints for reporting
final complaintsByStatusProvider =
FutureProvider.family<List<Complaint>, ComplaintStatus>(
      (ref, status) async {
    final repo = ref.watch(complaintRepositoryProvider);
    return repo.getComplaintsByStatus(status);
  },
);

/// Search complaints by priority
final complaintsByPriorityProvider =
FutureProvider.family<List<Complaint>, Priority>(
      (ref, priority) async {
    final repo = ref.watch(complaintRepositoryProvider);
    return repo.getComplaintsByPriority(priority);
  },
);

// ============================================================
// STATEFUL PROVIDERS (Mutable State)
// ============================================================

/// Tracks the CURRENTLY SELECTED COMPLAINT (detail view)
///
/// Why separate from data?
///   - Data provider (allComplaintsProvider) = all complaints
///   - State provider = which one is selected right now
///
/// Example:
///   User sees complaint list, taps "Camera 2 down"
///   → Call ref.read(selectedComplaintProvider.notifier).select(complaint)
///   → Detail screen rebuilds showing that complaint
///
/// Type: StateNotifierProvider
/// Why StateNotifier? Mutable state with custom logic
final selectedComplaintProvider =
StateNotifierProvider<SelectedComplaintNotifier, Complaint?>(
      (ref) => SelectedComplaintNotifier(null),
);

class SelectedComplaintNotifier extends StateNotifier<Complaint?> {
  SelectedComplaintNotifier(super.state);

  /// Select a complaint (user tapped it)
  void select(Complaint complaint) {
    state = complaint;
  }

  /// Clear selection (user went back to list)
  void clear() {
    state = null;
  }
}

// ============================================================
// FILTER STATE PROVIDERS
// ============================================================

/// Tracks complaint list filters applied by user
///
/// Example:
///   User opens filter menu → selects "Status: Urgent" + "Priority: High"
///   → These filters stored in this provider
///   → Complaint list rebuilds showing only matching complaints
///
/// Why StateNotifier?
///   Multiple filters, each can change independently
///   Need custom logic to apply/remove filters
final complaintFilterProvider =
StateNotifierProvider<ComplaintFilterNotifier, ComplaintFilter>(
      (ref) => ComplaintFilterNotifier(const ComplaintFilter()),
);

class ComplaintFilterNotifier extends StateNotifier<ComplaintFilter> {
  ComplaintFilterNotifier(super.state);

  void setStatus(ComplaintStatus? status) {
    state = state.copyWith(status: status);
  }

  void setPriority(Priority? priority) {
    state = state.copyWith(priority: priority);
  }

  void setTechnician(int? technicianId) {
    state = state.copyWith(technicianId: technicianId);
  }

  void clearFilters() {
    state = const ComplaintFilter();
  }
}

/// Data class for complaint filters
class ComplaintFilter {
  final ComplaintStatus? status;
  final Priority? priority;
  final int? technicianId;
  final String? searchQuery;

  const ComplaintFilter({
    this.status,
    this.priority,
    this.technicianId,
    this.searchQuery,
  });

  ComplaintFilter copyWith({
    ComplaintStatus? status,
    Priority? priority,
    int? technicianId,
    String? searchQuery,
  }) {
    return ComplaintFilter(
      status: status ?? this.status,
      priority: priority ?? this.priority,
      technicianId: technicianId ?? this.technicianId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool matches(Complaint complaint) {
    if (status != null && complaint.status != status) return false;
    if (priority != null && complaint.priority != priority) return false;
    if (technicianId != null && complaint.assignedTechnicianId != technicianId) {
      return false;
    }
    return true;
  }
}

// ============================================================
// COMPUTED PROVIDERS (Derived Data)
// ============================================================

/// Complaints filtered by current filter settings
///
/// Dependencies: allComplaintsProvider + complaintFilterProvider
/// Riverpod auto-recalculates when EITHER changes
///
/// Example flow:
///   1. User loads app → allComplaintsProvider fetches from DB
///   2. User selects "Urgent" filter
///   3. complaintFilterProvider updates
///   4. filteredComplaintsProvider recalculates
///   5. UI automatically rebuilds with filtered list
final filteredComplaintsProvider = FutureProvider<List<Complaint>>((ref) async {
  final allComplaints = await ref.watch(allComplaintsProvider.future);
  final filter = ref.watch(complaintFilterProvider);

  // Apply filters
  var filtered = allComplaints.where((c) => filter.matches(c)).toList();

  // Apply search if set
  if (filter.searchQuery != null && filter.searchQuery!.isNotEmpty) {
    final query = filter.searchQuery!.toLowerCase();
    filtered = filtered
        .where((c) =>
    c.title.toLowerCase().contains(query) ||
        c.description.toLowerCase().contains(query))
        .toList();
  }

  return filtered;
});

/// Get single complaint by ID
///
/// Used by: Detail screen to refresh a specific complaint
final complaintByIdProvider = FutureProvider.family<Complaint?, int>(
      (ref, complaintId) async {
    final repo = ref.watch(complaintRepositoryProvider);
    return repo.getComplaintById(complaintId);
  },
);

// ============================================================
// DASHBOARD STATISTICS
// ============================================================

/// Count of pending complaints
///
/// Used by: Dashboard badge showing how many pending
final pendingComplaintCountProvider = FutureProvider<int>((ref) async {
  final pending = await ref.watch(unresolvedComplaintsProvider.future);
  return pending.length;
});

/// Count of overdue complaints
///
/// Used by: Alerts, dashboard urgent count
final overdueComplaintCountProvider = FutureProvider<int>((ref) async {
  final overdue = await ref.watch(overdueComplaintsProvider.future);
  return overdue.length;
});

// ============================================================
// EXPLANATION: .family Modifier
// ============================================================
//
// Regular provider:
//   final complaintsProvider = FutureProvider<List<Complaint>>((ref) async {
//     return repo.getAllComplaints();
//   });
//   // Always returns same data (all complaints)
//
// Family provider:
//   final complaintsByCustomerProvider =
//     FutureProvider.family<List<Complaint>, int>((ref, customerId) async {
//       return repo.getComplaintsForCustomer(customerId);
//     });
//   // Takes a parameter (customerId)
//   // Returns DIFFERENT data based on parameter
//
// Usage difference:
//   // Regular:
//   ref.watch(complaintsProvider)
//
//   // Family:
//   ref.watch(complaintsByCustomerProvider(5))    // customer 5
//   ref.watch(complaintsByCustomerProvider(10))   // customer 10
//   // Each parameter value is cached separately!
//
// Riverpod caches by (provider + parameter):
//   - complaintsByCustomerProvider(5) cached
//   - complaintsByCustomerProvider(10) cached
//   - No duplicate fetches for same parameter
//
// ============================================================

// ============================================================
// EXPLANATION: StateNotifier vs FutureProvider
// ============================================================
//
// FutureProvider:
//   - For async data from DB
//   - Read-only (no mutations)
//   - Automatically handles loading/error/success
//   - Example: final complaints = await repo.getAllComplaints()
//
// StateNotifierProvider:
//   - For mutable state (can be changed by user)
//   - Synchronous (immediate, no async)
//   - Holds current value + methods to change it
//   - Example: selectedComplaint (user taps it, changes immediately)
//
// Combining them:
//   - FutureProvider for data from database
//   - StateNotifierProvider for UI state (selections, filters)
//   - StateNotifierProvider might call methods on FutureProvider data
//
// ============================================================