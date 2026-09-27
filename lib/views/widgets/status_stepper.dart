import 'package:flutter/material.dart';
import '../../database/drift_database.dart';

class StatusStepper extends StatelessWidget {
  final ComplaintStatus currentStatus;
  final VoidCallback onAdvance;

  const StatusStepper({
    super.key,
    required this.currentStatus,
    required this.onAdvance,
  });

  static const _forwardSteps = [
    ComplaintStatus.newStatus,
    ComplaintStatus.assigned,
    ComplaintStatus.inProgress,
    ComplaintStatus.resolved,
  ];

  static const _labels = {
    ComplaintStatus.newStatus: 'New',
    ComplaintStatus.assigned: 'Assigned',
    ComplaintStatus.inProgress: 'In Progress',
    ComplaintStatus.resolved: 'Resolved',
  };

  @override
  Widget build(BuildContext context) {
    final isReopened = currentStatus == ComplaintStatus.reopened;
    // Reopened resets the workflow to the start — it needs a fresh
    // technician assignment to move forward again, same as a brand-new complaint.
    final effectiveStatus = isReopened ? ComplaintStatus.newStatus : currentStatus;
    final currentIndex = _forwardSteps.indexOf(effectiveStatus);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReopened)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withOpacity(0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.replay, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Text('Reopened — needs another visit',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        Row(
          children: List.generate(_forwardSteps.length * 2 - 1, (i) {
            if (i.isOdd) {
              final stepBeforeIndex = i ~/ 2;
              final isCompleted = stepBeforeIndex < currentIndex;
              return Expanded(
                child: Container(
                  height: 3,
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                ),
              );
            }
            final stepIndex = i ~/ 2;
            final step = _forwardSteps[stepIndex];
            final isDone = stepIndex < currentIndex;
            final isCurrent = stepIndex == currentIndex;
            // "Assigned" (index 1) can never be tapped directly — it only
            // happens by actually picking a technician below. This is what
            // makes reopen → reassign → auto-advance work correctly.
            final isNextTappable = stepIndex == currentIndex + 1 && stepIndex != 1;

            Color bg;
            Color fg;
            if (isDone) {
              bg = Colors.green;
              fg = Colors.white;
            } else if (isCurrent) {
              bg = Theme.of(context).primaryColor;
              fg = Colors.white;
            } else {
              bg = Colors.grey.shade300;
              fg = Colors.grey.shade600;
            }

            return GestureDetector(
              onTap: isNextTappable ? onAdvance : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: bg,
                    child: isDone
                        ? Icon(Icons.check, size: 16, color: fg)
                        : Text('${stepIndex + 1}',
                        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 64,
                    child: Text(
                      _labels[step]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isNextTappable ? Theme.of(context).primaryColor : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        if (currentIndex >= 0 && currentIndex < _forwardSteps.length - 1)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              currentIndex == 0
                  ? 'Assign a technician below to move this forward'
                  : 'Tap "${_labels[_forwardSteps[currentIndex + 1]]}" above to advance',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }
}