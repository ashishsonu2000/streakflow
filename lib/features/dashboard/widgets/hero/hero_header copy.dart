import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

class HeroHeader extends StatelessWidget {
  const HeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.local_fire_department,
          color: AppColors.white,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          "CURRENT STREAK",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
