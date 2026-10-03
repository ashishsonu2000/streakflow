import 'package:flutter/material.dart';

import 'settings_tile.dart';

class SettingsActionTile extends StatelessWidget {
  const SettingsActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? color;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: title,
      subtitle: subtitle,
      onTap: () async {
        await onTap();

        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$title completed"),
          ),
        );
      },
    );
  }
}
