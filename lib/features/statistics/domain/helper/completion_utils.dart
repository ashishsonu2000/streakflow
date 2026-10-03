class CompletionUtils {
  const CompletionUtils._();

  static double calculateRate({
    required int completed,
    required int total,
  }) {
    if (total == 0) {
      return 0.0;
    }

    return completed / total;
  }
}
