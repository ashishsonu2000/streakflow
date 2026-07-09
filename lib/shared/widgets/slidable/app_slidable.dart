import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppSlidable extends StatelessWidget {
  const AppSlidable({
    super.key,
    required this.child,
    this.onArchive,
    this.onDelete,
  });

  final Widget child;

  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      closeOnScroll: true,
      endActionPane: ActionPane(
        extentRatio: .45,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            borderRadius: BorderRadius.circular(18),
            spacing: 6,
            onPressed: (_) {
              HapticFeedback.lightImpact();
              onArchive?.call();
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.archive_outlined,
            label: 'Archive',
          ),
          SlidableAction(
            borderRadius: BorderRadius.circular(18),
            spacing: 6,
            onPressed: (_) {
              HapticFeedback.mediumImpact();
              onDelete?.call();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: child,
    );
  }
}
