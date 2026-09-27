import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/call_launcher.dart';
import '../../utils/validators.dart';
import '../../viewmodels/technician_manager_viewmodel.dart';

class TechnicianManagerScreen extends ConsumerWidget {
  const TechnicianManagerScreen({super.key});

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final specialtyController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Technician'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => Validators.requiredField(v, 'Name'),
              ),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: Validators.phone,
              ),
              TextFormField(
                controller: specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty (optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await ref.read(technicianManagerViewModelProvider.notifier).addTechnician(
                  nameController.text.trim(),
                  phoneController.text.trim(),
                  specialtyController.text.trim().isEmpty ? null : specialtyController.text.trim(),
                );
                if (ctx.mounted) Navigator.pop(ctx);
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add technician: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(technicianManagerViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Technicians')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (technicians) {
          if (technicians.isEmpty) {
            return const Center(child: Text('No technicians added yet'));
          }
          return ListView.builder(
            itemCount: technicians.length,
            itemBuilder: (context, i) {
              final t = technicians[i];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(t.name),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.call, size: 14, color: Colors.green),
                      const SizedBox(width: 4),
                      Text(t.phone),
                      if (t.specialty != null) ...[
                        const Text(' · '),
                        Expanded(
                          child: Text(
                            t.specialty!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: t.active ? Colors.green : Colors.grey,
                    child: Text(t.name[0].toUpperCase()),
                  ),
                  trailing: Switch(
                    value: t.active,
                    onChanged: (val) {
                      final vm = ref.read(
                        technicianManagerViewModelProvider.notifier,
                      );
                      val ? vm.activate(t.id) : vm.deactivate(t.id);
                    },
                  ),
                  onTap: () {
                    if (t.phone.isNotEmpty) {
                      callPhoneNumber(context, t.phone);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
