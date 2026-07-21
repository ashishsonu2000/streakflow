import '../enums/completion_status.dart';

extension CompletionStatusExtension on CompletionStatus {
  bool get isCompleted => this == CompletionStatus.completed;

  bool get isSkipped => this == CompletionStatus.skipped;

  bool get isMissed => this == CompletionStatus.missed;

  bool get isSuccessful => isCompleted;
}
