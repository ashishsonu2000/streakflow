class NotificationRequest {
  const NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.hour,
    required this.minute,
  });

  final int id;

  final String title;

  final String body;

  final int hour;

  final int minute;
}