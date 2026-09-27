import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tech_track/views/screens/technician_manager_screen.dart';
import '../../database/drift_database.dart';
import '../../providers/technician_provider.dart';
import '../../utils/call_launcher.dart';
import '../../viewmodels/complaint_detail_viewmodel.dart';
import '../widgets/status_badge.dart';
import '../widgets/status_stepper.dart';

class ComplaintDetailScreen extends ConsumerStatefulWidget {
  final int complaintId;
  const ComplaintDetailScreen({super.key, required this.complaintId});

  @override
  ConsumerState<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends ConsumerState<ComplaintDetailScreen> {
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = complaintDetailViewModelProvider(widget.complaintId);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Complaint Detail')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (d) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(d.complaint.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  StatusBadge(status: d.complaint.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(d.complaint.description),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Customer', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(d.customer?.name ?? 'Unknown'),
                      Row(
                        children: [
                          Text(d.customer?.phone ?? ''),
                          IconButton(
                            icon: const Icon(Icons.call, size: 18, color: Colors.green),
                            onPressed: () => callPhoneNumber(context, d.customer?.phone ?? ''),
                          ),
                        ],
                      ),
                      Text(d.customer?.address ?? ''),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Status change
              // Status stepper
              const Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              StatusStepper(
                currentStatus: d.complaint.status,
                onAdvance: () async {
                  final next = _nextStatusLabel(d.complaint.status);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirm status change'),
                      content: Text('Mark this complaint as "$next"?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirm')),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    vm.advanceStatus();
                  }
                },
              ),
              if (d.complaint.status == ComplaintStatus.resolved) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.replay, color: Colors.red),
                    label: const Text('Reopen Complaint', style: TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Reopen this complaint?'),
                          content: const Text(
                              'This means the issue was not actually resolved. The complaint will go back to open status.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Reopen'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        vm.reopen();
                      }
                    },
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // Assign technician
              const Text('Assign Technician', style: TextStyle(fontWeight: FontWeight.bold)),
              Consumer(
                builder: (context, ref, _) {
                  final techsAsync = ref.watch(activeTechniciansProvider);
                  return techsAsync.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (e, st) => Text('Error: $e'),
                    data: (techs) {
                      if (techs.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                              const SizedBox(width: 8),
                              const Expanded(child: Text('No active technicians. Add one first.')),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const TechnicianManagerScreen()),
                                ),
                                child: const Text('Add'),
                              ),
                            ],
                          ),
                        );
                      }
                      return DropdownButton<int>(
                        isExpanded: true,
                        hint: const Text('Select technician'),
                        value: d.technician?.id,
                        items: techs
                            .map((t) => DropdownMenuItem(value: t.id, child: Text(t.name)))
                            .toList(),
                        onChanged: (id) {
                          if (id != null) vm.assignTechnician(id);
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),

              // Notes / timeline
              const Text('Activity Timeline', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText: 'Add a note...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_noteController.text.trim().isNotEmpty) {
                        vm.addNote(_noteController.text.trim());
                        _noteController.clear();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...d.notes.map((n) => Card(
                child: ListTile(
                  title: Text(n.textNote),
                  subtitle: Text('${n.createdAt.toLocal()}'.split('.')[0]),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  String _nextStatusLabel(ComplaintStatus current) {
    switch (current) {
      case ComplaintStatus.newStatus:
        return 'Assigned';
      case ComplaintStatus.assigned:
        return 'In Progress';
      case ComplaintStatus.inProgress:
        return 'Resolved';
      default:
        return '';
    }
  }
}