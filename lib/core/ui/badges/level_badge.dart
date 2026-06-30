import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import 'app_badge.dart';

class LevelBadge extends StatelessWidget {
  final int level;

  const LevelBadge({
    super.key,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      icon: Icons.workspace_premium,
      text: "LEVEL $level",
      backgroundColor: AppColors.levelBlue,
    );
  }
}
