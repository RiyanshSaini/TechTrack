import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> callPhoneNumber(BuildContext context, String phone) async {
  if (phone.trim().isEmpty) return;

  final uri = Uri(scheme: 'tel', path: phone.trim());
  final launched = await launchUrl(uri);

  if (!launched && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not open dialer for $phone')),
    );
  }
}