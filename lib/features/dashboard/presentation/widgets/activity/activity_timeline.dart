import 'package:flutter/material.dart';


import '../../../domain/models/activity_item.dart';
import 'activity_tile.dart'; // ✅ your existing tile

class ActivityTimeline extends StatelessWidget {
  const ActivityTimeline({
    super.key,
    required this.activities,
  });

  final List<ActivityItem> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Text("No activity yet"),
      );
    }

    final grouped = _groupActivities(activities);

    return ListView(
      children: grouped.entries.map((entry) {
        return _DaySection(
          label: entry.key,
          items: entry.value,
        );
      }).toList(),
    );
  }
}

////////////////////////////////////////////////////////////
/// GROUPING
////////////////////////////////////////////////////////////

Map<String, List<ActivityItem>> _groupActivities(
    List<ActivityItem> activities,
    ) {
  final map = <String, List<ActivityItem>>{};

  for (final item in activities) {
    final key = item.dayLabel;

    map.putIfAbsent(key, () => []);
    map[key]!.add(item);
  }

  return map;
}

////////////////////////////////////////////////////////////
/// DAY SECTION
////////////////////////////////////////////////////////////

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.label,
    required this.items,
  });

  final String label;
  final List<ActivityItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const SizedBox(height: 8),

          // ✅ USE YOUR EXISTING TILE
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ActivityTile(activity: item),
            ),
          ),
        ],
      ),
    );
  }
}