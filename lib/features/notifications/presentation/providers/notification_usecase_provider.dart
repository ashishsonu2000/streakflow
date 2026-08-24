import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/notification_service.dart';
import '../../domain/usecases/cancel_habit_reminder_usecase.dart';
import '../../domain/usecases/schedule_habit_reminder_usecase.dart';


import 'notification_service_provider.dart';

final scheduleHabitReminderUseCaseProvider =
Provider<ScheduleHabitReminderUseCase>(
      (ref) {
    return ScheduleHabitReminderUseCase(
      ref.read(notificationServiceProvider),
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