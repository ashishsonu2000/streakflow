import 'package:flutter/material.dart';

class AppTimelineTile extends StatelessWidget {
  const AppTimelineTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
  });

  final Widget leading;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: leading,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
