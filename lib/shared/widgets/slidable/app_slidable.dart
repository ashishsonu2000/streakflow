import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppSlidable extends StatelessWidget {
  const AppSlidable({
    super.key,
    required this.child,
    this.onEdit,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
  });

  final Widget child;

  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      startActionPane: ActionPane(
        extentRatio: .45,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit?.call(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit_outlined,
            label: "Edit",
          ),
          SlidableAction(
            onPressed: (_) => onDuplicate?.call(),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.copy_outlined,
            label: "Copy",
          ),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: .45,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onArchive?.call(),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.archive_outlined,
            label: "Archive",
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: "Delete",
          ),
        ],
      ),
      child: child,
    );
  }
}
