import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:aqar_morocco_mobile/core/theme/app_theme.dart';

class VerificationBadge extends StatelessWidget {
  final double size;
  final bool isUser;

  const VerificationBadge({
    super.key,
    this.size = 16,
    this.isUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        LucideIcons.check,
        size: size * 0.7,
        color: Colors.white,
      ),
    );
  }
}
