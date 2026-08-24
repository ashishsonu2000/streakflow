import 'package:flutter/material.dart';

class AchievementTesterPage
    extends StatelessWidget {
  const AchievementTesterPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Achievement Tester',
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text(
              'Unlock all achievements',
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Unlock',
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Reset achievements',
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Reset',
              ),
            ),
          ),
        ],
      ),
    );
  }
}