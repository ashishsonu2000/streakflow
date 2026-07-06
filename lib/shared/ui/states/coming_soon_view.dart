import 'package:flutter/material.dart';

import 'empty_view.dart';

class ComingSoonView extends StatelessWidget {
  const ComingSoonView({
    super.key,
    this.title = 'Coming Soon',
    this.message = 'This feature is under development.',
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return EmptyView(
      title: title,
      message: message,
      icon: Icons.construction_outlined,
    );
  }
}
