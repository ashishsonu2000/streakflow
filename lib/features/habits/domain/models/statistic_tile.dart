import 'package:flutter/material.dart';

class StatisticTileModel {
  const StatisticTileModel({
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  final String title;

  final String value;

  final IconData icon;

  final Color? color;
}
