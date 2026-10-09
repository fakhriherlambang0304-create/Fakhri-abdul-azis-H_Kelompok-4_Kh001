import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? url;

  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.url,
  });

  Future<void> _handlePressed() async {
    if (onPressed != null) {
      onPressed!();
    }

    if (url != null && url!.isNotEmpty) {
      final Uri uri = Uri.parse(url!);
      final bool success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        debugPrint('gagal membuka link');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasAction =
        onPressed != null || (url != null && url!.isNotEmpty);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: hasAction ? _handlePressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white30,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon), const SizedBox(width: 8)],
            Text(label),
          ],
        ),
      ),
    );
  }
}
