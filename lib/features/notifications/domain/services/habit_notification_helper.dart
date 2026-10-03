class HabitNotificationHelper {
  const HabitNotificationHelper._();

  static int notificationId(
      String habitId,
      ) {
    return habitId.hashCode.abs();
  }
}