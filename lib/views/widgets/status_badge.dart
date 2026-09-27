import 'package:flutter/material.dart';

import '../../database/drift_database.dart';


class StatusBadge extends StatelessWidget {
  final ComplaintStatus status;
  const StatusBadge({super.key, required this.status});

  Color _color() {
    switch (status) {
      case ComplaintStatus.newStatus:
        return Colors.blue;
      case ComplaintStatus.assigned:
        return Colors.orange;
      case ComplaintStatus.inProgress:
        return Colors.purple;
      case ComplaintStatus.resolved:
        return Colors.green;
      case ComplaintStatus.reopened:
        return Colors.red;
    }
  }

  String _label() {
    switch (status) {
      case ComplaintStatus.newStatus:
        return 'New';
      case ComplaintStatus.assigned:
        return 'Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.reopened:
        return 'Reopened';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color().withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color()),
      ),
      child: Text(
        _label(),
        style: TextStyle(color: _color(), fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}