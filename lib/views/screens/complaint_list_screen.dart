import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/complaint_list_viewmodel.dart';
import '../widgets/status_badge.dart';
import 'complaint_detail_screen.dart';

class ComplaintListScreen extends ConsumerStatefulWidget {
  final ComplaintListFilter filter;
  final String title;

  const ComplaintListScreen({
    super.key,
    this.filter = ComplaintListFilter.all,
    this.title = 'All Complaints',
  });

  @override
  ConsumerState<ComplaintListScreen> createState() => _ComplaintListScreenState();
}

class _ComplaintListScreenState extends ConsumerState<ComplaintListScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = complaintListViewModelProvider(widget.filter);
    final state = ref.watch(provider);
    final vm = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title/description',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    vm.search('');
                  },
                )
                    : null,
              ),
              onChanged: (val) => vm.search(val),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
              data: (complaints) {
                if (complaints.isEmpty) {
                  return const Center(child: Text('No complaints found'));
                }
                return RefreshIndicator(
                  onRefresh: vm.refresh,
                  child: ListView.builder(
                    itemCount: complaints.length,
                    itemBuilder: (context, i) {
                      final c = complaints[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(c.title),
                          subtitle: Text(
                            '${c.priority.name.toUpperCase()} · ${c.createdAt.toLocal()}'.split('.')[0],
                          ),
                          trailing: StatusBadge(status: c.status),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComplaintDetailScreen(complaintId: c.id),
                              ),
                            );
                            vm.refresh(); // in case status changed in detail screen
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}