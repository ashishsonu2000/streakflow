import '../../../habits/data/entities/habit_log_entity.dart';
import '../../../habits/domain/models/habit.dart';
import 'quick_action_model.dart';

class DashboardContext {
  const DashboardContext({
    required this.habits,
    required this.logs,
    required this.userName,
    required this.greeting,
    required this.quickActions,
  });

  final List<Habit> habits;
  final List<HabitLogEntity> logs;

  final String greeting;
  final String userName;

  final List<QuickActionModel> quickActions;
}
