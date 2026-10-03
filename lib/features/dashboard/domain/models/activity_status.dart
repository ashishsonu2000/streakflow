enum ActivityStatus {
  completed,
  skipped,
  failed,
  pending,
}

extension ActivityStatusExtension on ActivityStatus {
  String get label {
    switch (this) {
      case ActivityStatus.completed:
        return "Completed";
      case ActivityStatus.skipped:
        return "Skipped";
      case ActivityStatus.failed:
        return "Failed";
      case ActivityStatus.pending:
        return "Pending";
    }
  }
}
