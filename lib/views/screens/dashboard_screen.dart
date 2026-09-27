import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/notification_service.dart';
import '../../viewmodels/complaint_list_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/status_badge.dart';
import 'complaint_list_screen.dart';
import 'add_complaint_screen.dart';
import 'technician_manager_screen.dart';
import 'complaint_detail_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final granted = await NotificationService.instance.requestPermission();
      if (granted) {
        await NotificationService.instance.scheduleDailyOverdueDigest();
      }

      final canScheduleExact = await NotificationService.instance.canScheduleExactAlarms();
      if (!canScheduleExact && mounted) {
        _showExactAlarmDialog();
      }
    });
  }

  void _showExactAlarmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Allow Exact Reminders'),
        content: const Text(
          'To notify you at the exact time a complaint is due, TechTrack needs '
              '"Alarms & reminders" permission. Please enable it on the next screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Not Now'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              NotificationService.instance.requestExactAlarmPermission();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = this.ref.watch(dashboardViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TechTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TechnicianManagerScreen(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Quick Add'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddComplaintScreen()),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (data) => RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardViewModelProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Pending',
                      count: data.pendingCount,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintListScreen(
                            filter: ComplaintListFilter.pending,
                            title: 'Pending Complaints',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Overdue',
                      count: data.overdueCount,
                      color: Colors.red,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintListScreen(
                            filter: ComplaintListFilter.overdue,
                            title: 'Overdue Complaints',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'In Progress',
                      count: data.inProgressCount,
                      color: Colors.purple,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintListScreen(
                            filter: ComplaintListFilter.inProgress,
                            title: 'In Progress',
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Resolved Today',
                      count: data.resolvedTodayCount,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ComplaintListScreen(
                            filter: ComplaintListFilter.resolvedToday,
                            title: 'Resolved Today',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Oldest Unresolved',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (data.oldestUnresolved.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('Nothing pending 🎉'),
                )
              else
                ...data.oldestUnresolved.map(
                  (c) => Card(
                    child: ListTile(
                      title: Text(c.title),
                      subtitle: Text(
                        'Logged: ${c.createdAt.toLocal()}'.split('.')[0],
                      ),
                      trailing: StatusBadge(status: c.status),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ComplaintDetailScreen(complaintId: c.id),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final VoidCallback? onTap;

  const _StatCard({
    required this.label,
    required this.count,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
