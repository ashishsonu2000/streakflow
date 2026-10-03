import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes.dart';

class TestAchievementTile extends StatelessWidget {
  const TestAchievementTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.emoji_events_outlined,
      ),
      title: const Text(
        'Test Achievements',
      ),
      subtitle: const Text(
        'Unlock achievements instantly',
      ),
      trailing: const Icon(
        Icons.chevron_right,
      ),
      onTap: () {
        context.push(
          AppRoutes.achievementTester,
        );
      },
    );
  }
}