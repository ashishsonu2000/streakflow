import '../../domain/models/habit.dart';
import '../../domain/models/habit_card_view_model.dart';

class HabitCardViewModelMapper {
  const HabitCardViewModelMapper();

  HabitCardViewModel map(Habit habit) {
    return HabitCardViewModel(
      habit: habit,
    );
  }
}
