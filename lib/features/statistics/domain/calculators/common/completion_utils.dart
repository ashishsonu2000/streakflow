class CompletionUtils {
  const CompletionUtils._();

  static double calculateRate({
    required int completed,
    required int total,
  }) {
    if (total == 0) {
      return 0;
    }

    return completed / total;
  }

  static double calculatePercentage({
    required int completed,
    required int total,
  }) {
    return calculateRate(
          completed: completed,
          total: total,
        ) *
        100;
  }
}
