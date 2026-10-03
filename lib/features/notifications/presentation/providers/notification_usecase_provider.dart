import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entitlements/entitlement_provider.dart';


import '../../domain/usecases/cancel_habit_reminder_usecase.dart';
import '../../domain/usecases/schedule_habit_reminder_usecase.dart';


import 'notification_service_provider.dart';

final scheduleHabitReminderUseCaseProvider =
Provider<ScheduleHabitReminderUseCase>(
      (ref) {
    return ScheduleHabitReminderUseCase(
      ref.read(notificationServiceProvider),
      maxRemindersPerHabit: () =>
          ref.read(featureAccessProvider).remindersPerHabit,
    );
  },
);

final cancelHabitReminderUseCaseProvider =
Provider<CancelHabitReminderUseCase>(
      (ref) {
    return CancelHabitReminderUseCase(
      ref.read(notificationServiceProvider),
    );
  },
);