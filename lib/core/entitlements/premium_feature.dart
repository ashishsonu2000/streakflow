// =====================================================================
// PREMIUM FEATURES
//
// Every capability that requires StreakFlow Premium. Gate features by
// asking FeatureAccess.canUse(PremiumFeature.x) — never by checking the
// tier directly in UI code.
//
// Everything that exists in the Free app today stays free; Premium adds
// new capabilities on top.
// =====================================================================

enum PremiumFeature {
  unlimitedHabits(
    title: 'Unlimited habits',
    description: 'Track as many active habits as you like.',
  ),
  adFree(
    title: 'Ad-free experience',
    description: 'No advertisements anywhere in StreakFlow.',
  ),
  productivityScore(
    title: 'Productivity score',
    description: 'One weekly score from your completion, consistency '
        'and streaks.',
  ),
  advancedInsights(
    title: 'Advanced insights',
    description: 'Your best days, strongest and weakest habits, and '
        'week-over-week trends.',
  ),
  premiumReports(
    title: 'Weekly & monthly reports',
    description: 'A shareable summary of each week or month.',
  ),
  premiumThemes(
    title: 'Premium themes',
    description: 'Extra color themes for light and dark mode.',
  ),
  advancedAchievements(
    title: 'Advanced achievements',
    description: 'Long-term milestones for dedicated habit builders.',
  ),
  csvExport(
    title: 'CSV export',
    description: 'Export habits and history for spreadsheets.',
  );

  const PremiumFeature({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}
