import 'package:flutter/material.dart';

class QuickActionModel {
  const QuickActionModel({
    required this.title,
    required this.icon,
    required this.route,
  });

  final String title;

  final IconData icon;

  final String route;
}
