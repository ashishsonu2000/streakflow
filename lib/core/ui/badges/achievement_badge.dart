import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'app_badge.dart';

class AchievementBadge extends StatelessWidget {
  final String achievement;

  const AchievementBadge({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      icon: Icons.emoji_events,
      text: achievement,
      backgroundColor: AppColors.gold,
      foregroundColor: Colors.black87,
    );
  }
}
