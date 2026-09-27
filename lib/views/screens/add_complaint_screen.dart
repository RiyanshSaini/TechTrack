import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tech_track/utils/validators.dart';
import '../../database/drift_database.dart';
import '../../providers/customer_provider.dart';
import '../../viewmodels/add_complaint_viewmodel.dart';
import '../../viewmodels/add_customer_viewmodel.dart';

class AddComplaintScreen extends ConsumerStatefulWidget {
  const AddComplaintScreen({super.key});

  @override
  ConsumerState<AddComplaintScreen> createState() => _AddComplaintScreenState();
}

class _AddComplaintScreenState extends ConsumerState<AddComplaintScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _custNameController = TextEditingController();
  final _custPhoneController = TextEditingController();
  final _custAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;
  bool _isNewCustomer = false;
  Priority _priority = Priority.normal;
  DateTime? _dueBy;
  bool _submitting = false;
  bool _submitLock = false;

  Future<void> _submit() async {

    if(!_formKey.currentState!.validate()) {
      return;
    }

    if (_submitLock) return;
    _submitLock = true;

    try {
      if (_titleController.text.trim().isEmpty) {
        _showError('Title is required');
        return;
      }
      if (_descController.text.trim().isEmpty) {
        _showError('Description is required');
        return;
      }

      setState(() => _submitting = true);

      int? customerId;

      if (_isNewCustomer) {
        final customer = await ref
            .read(addCustomerViewModelProvider.notifier)
            .submit(
              name: _custNameController.text.trim(),
              phone: _custPhoneController.text.trim(),
              address: _custAddressController.text.trim(),
            );
        if (customer == null) {
          _showError('Failed to create customer');
          return;
        }
        customerId = customer.id;
      } else {
        if (_selectedCustomer == null) {
          _showError('Select a customer');
          return;
        }
        customerId = _selectedCustomer!.id;
      }

      final success = await ref
          .read(addComplaintViewModelProvider.notifier)
          .submit(
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            customerId: customerId,
            priority: _priority,
            dueBy: _dueBy,
          );

      if (success && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        _showError('Failed to create complaint');
      }
    } finally {
      _submitLock = false;
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final customersAsync = ref.watch(allCustomersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('New Complaint')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [!_isNewCustomer, _isNewCustomer],
                onPressed: (i) => setState(() => _isNewCustomer = i == 1),
                borderRadius: BorderRadius.circular(8),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Existing'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (!_isNewCustomer)
                customersAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, st) => Text('Error: $e'),
                  data: (customers) {
                    if (customers.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.info_outline, color: Colors.orange),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'No existing customers yet.',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Add this one as a new customer to continue.',
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                icon: const Icon(Icons.person_add),
                                label: const Text('Add New Customer'),
                                onPressed: () =>
                                    setState(() => _isNewCustomer = true),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return DropdownButtonFormField<Customer>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Select Customer',
                      ),
                      value: _selectedCustomer,
                      items: customers
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text('${c.name} (${c.phone})'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => _selectedCustomer = val),
                    );
                  },
                )
              else
                Column(
                  children: [
                    TextFormField(
                      controller: _custNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                      ),
                      validator:(v) =>  Validators.requiredField(v, "Customer Name"),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _custPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone',
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.phone,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _custAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Address/Site',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text(
                'Complaint',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title / Issue Summary',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<Priority>(
                decoration: const InputDecoration(
                  labelText: 'Priority',
                  border: OutlineInputBorder(),
                ),
                value: _priority,
                items: Priority.values
                    .map(
                      (p) => DropdownMenuItem(
                        value: p,
                        child: Text(p.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _priority = val!),
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  _dueBy == null
                      ? 'No due date set'
                      : 'Due: ${DateFormat('MMM d, yyyy · h:mm a').format(_dueBy!)}'
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date == null || !context.mounted) return;

                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time == null) return;

                    final combined = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );

                    setState(() => _dueBy = combined);
                  },
                  child: const Text('Set Due Date'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _submitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save Complaint'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
