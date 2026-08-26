import 'package:flutter/material.dart';

import '../../../../../../core/ui/section/app_section_header.dart';
import '../../../../../dashboard/domain/models/activity_item.dart';
import '../../../../../dashboard/presentation/widgets/activity/activity_tile.dart';

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
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFEEF4FA),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF2563EB).withValues(
              alpha: 0.20,
            ),
            width: 1.1,
          ),
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
              // =====================================================
              // HEADER
              // =====================================================

              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      size: 21,
                      color: Color(0xFF2563EB),
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

              // =====================================================
              // ACTIVITY
              // =====================================================

              if (activities.isEmpty)
                const ActivityEmpty()
              else
                ...activities.map(
                      (activity) {
                    return ActivityTile(
                      activity: activity,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}