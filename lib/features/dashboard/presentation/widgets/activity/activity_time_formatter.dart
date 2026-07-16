class ActivityTimeFormatter {
  static String format(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return "Just now";
    }

    if (diff.inHours < 1) {
      return "${diff.inMinutes} min ago";
    }

    if (diff.inDays < 1) {
      return "${diff.inHours} hr ago";
    }

    if (diff.inDays == 1) {
      return "Yesterday";
    }

    return "${diff.inDays} days ago";
  }
}
