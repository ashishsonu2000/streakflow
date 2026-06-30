import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HabitSummary extends Equatable {
  final String id;

  final String title;

  final String subtitle;

  final IconData icon;

  final Color color;

  final bool completed;

  final int points;

  final int streak;

  const HabitSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.completed,
    required this.points,
    required this.streak,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        icon,
        color,
        completed,
        points,
        streak,
      ];
}
