// =====================================================================
// HELPERS
// =====================================================================

double habitStatsPercentage(
    int completed,
    int total,
    ) {
  if (total <= 0) {
    return 0;
  }

  return completed / total * 100;
}

String formatHabitStatsDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${months[date.month - 1]} '
      '${date.day}, ${date.year}';
}
