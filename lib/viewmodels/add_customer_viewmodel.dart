import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/drift_database.dart';
import '../providers/customer_provider.dart';
import '../providers/repository_providers.dart';


final addCustomerViewModelProvider =
StateNotifierProvider<AddCustomerViewModel, AsyncValue<Customer?>>(
      (ref) => AddCustomerViewModel(ref),
);

class AddCustomerViewModel extends StateNotifier<AsyncValue<Customer?>> {
  final Ref ref;

  AddCustomerViewModel(this.ref) : super(const AsyncValue.data(null));

  Future<Customer?> submit({
    required String name,
    required String phone,
    required String address,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(customerRepositoryProvider);
      final customer = await repo.createCustomer(
        name: name,
        phone: phone,
        address: address,
        notes: notes,
      );
      ref.invalidate(allCustomersProvider);
      ref.invalidate(activeCustomersProvider);
      if (mounted) state = AsyncValue.data(customer);   // ADD mounted check
      return customer;
    } catch (e, st) {
      if (mounted) state = AsyncValue.error(e, st);
      return null;
    }
  }
}