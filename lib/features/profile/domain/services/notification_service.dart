abstract class NotificationService {
  Future<void> initialize();

  Future<void> schedule({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  });

  Future<void> cancel(
      int id,
      );
}