import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/drift_database.dart';
import 'repository_providers.dart';

// ============================================================
// ASYNC DATA PROVIDERS
// ============================================================

/// Get all customers
final allCustomersProvider = FutureProvider<List<Customer>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getAllCustomers();
});

/// Get active customers (those with open complaints)
final activeCustomersProvider = FutureProvider<List<Customer>>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getActiveCustomers();
});

/// Get single customer by ID with stats
final customerWithStatsProvider =
FutureProvider.family<Map<String, dynamic>?, int>(
      (ref, customerId) async {
    final repo = ref.watch(customerRepositoryProvider);
    return repo.getCustomerWithStats(customerId);
  },
);

/// Get customer by phone number
///
/// Used by: When customer calls in, lookup by phone
final customerByPhoneProvider = FutureProvider.family<Customer?, String>(
      (ref, phone) async {
    final repo = ref.watch(customerRepositoryProvider);
    return repo.getCustomerByPhone(phone);
  },
);

// ============================================================
// SEARCH PROVIDERS
// ============================================================

/// Search customers by name/phone/address
final customerSearchProvider =
FutureProvider.family<List<Customer>, String>(
      (ref, query) async {
    final repo = ref.watch(customerRepositoryProvider);
    return repo.searchCustomers(query);
  },
);

/// Get customers with specific complaint status
///
/// Used by: "Which sites have urgent issues?"
final customersByComplaintStatusProvider =
FutureProvider.family<List<Customer>, ComplaintStatus>(
      (ref, status) async {
    final repo = ref.watch(customerRepositoryProvider);
    return repo.getCustomersWithComplaintStatus(status);
  },
);

// ============================================================
// STATEFUL PROVIDERS
// ============================================================

/// Currently selected customer (detail view)
final selectedCustomerProvider =
StateNotifierProvider<SelectedCustomerNotifier, Customer?>(
      (ref) => SelectedCustomerNotifier(null),
);

class SelectedCustomerNotifier extends StateNotifier<Customer?> {
  SelectedCustomerNotifier(super.state);

  void select(Customer customer) {
    state = customer;
  }

  void clear() {
    state = null;
  }
}

// ============================================================
// STATISTICS
// ============================================================

/// Customer with most unresolved complaints
///
/// Used by: Dashboard "Priority Site" widget
final customerWithMostIssuesProvider =
FutureProvider<Customer?>((ref) async {
  final repo = ref.watch(customerRepositoryProvider);
  return repo.getCustomerWithMostIssues();
});