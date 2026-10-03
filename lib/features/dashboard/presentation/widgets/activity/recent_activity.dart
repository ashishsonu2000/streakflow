import 'package:flutter/material.dart';

import '../../../../../core/ui/section/app_section_header.dart';
import '../../../domain/models/activity_item.dart';

import 'activity_empty.dart';
import 'activity_tile.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    super.key,
    required this.activities,
  });

  final List<ActivityItem> activities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: colors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),

          // =========================================================
          // THEME-AWARE CARD
          // =========================================================

          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
              colors.surfaceContainer,
              colors.surfaceContainerLow,
            ]
                : const [
              Color(0xFFF8FAFC),
              Color(0xFFEEF4FA),
            ],
          ),

          border: Border.all(
            color: isDark
                ? colors.outlineVariant.withValues(
              alpha: 0.70,
            )
                : const Color(0xFF2563EB).withValues(
              alpha: 0.20,
            ),
            width: 1.1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.18 : 0.035,
              ),
              blurRadius: isDark ? 16 : 18,
              offset: const Offset(0, 7),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            14,
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              // =======================================================
              // HEADER
              // =======================================================

              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? colors.primaryContainer.withValues(
                        alpha: 0.65,
                      )
                          : const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? colors.primary.withValues(
                          alpha: 0.25,
                        )
                            : const Color(0xFF2563EB)
                            .withValues(
                          alpha: 0.08,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.history_rounded,
                      size: 21,
                      color: isDark
                          ? colors.primary
                          : const Color(0xFF2563EB),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: AppSectionHeader(
                      title: 'Recent Activity',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =======================================================
              // ACTIVITY
              // =======================================================

              if (activities.isEmpty)
                const ActivityEmpty()
              else
                ...activities.map(
                      (activity) => ActivityTile(
                    activity: activity,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}