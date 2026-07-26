import 'package:flutter/material.dart';

import '../../../../../core/ui/chips/status_chip.dart';
import '../../../../../core/ui/headers/app_card_header.dart';
import '../../../../../core/ui/hero/app_hero_tags.dart';
import '../../../../../core/ui/icons/habit_icon.dart';
import '../../../domain/models/habit.dart';
import '../actions/habit_popup_menu.dart';
import 'habit_card_menu.dart';

class HabitCardHeader extends StatelessWidget {
  const HabitCardHeader({
    super.key,
    required this.habit,
    required this.onMenuSelected,
  });

  final Habit habit;
  final ValueChanged<HabitMenuAction> onMenuSelected;

  @override
  Widget build(BuildContext context) {
    return AppCardHeader(
      leading: Hero(
        tag: AppHeroTags.habitIcon(habit.id),
        child: HabitIcon(
          iconCodePoint: habit.iconCodePoint,
          color: Color(habit.colorValue),
        ),
      ),
      title: habit.title,
      subtitle: habit.description,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusChip(
            status: habit.archived ? AppStatus.archived : AppStatus.active,
          ),
          HabitCardMenu(
            onSelected: onMenuSelected,
          ),
        ],
      ),
    );
  }
}
