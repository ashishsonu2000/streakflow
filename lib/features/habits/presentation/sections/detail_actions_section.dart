import 'package:flutter/material.dart';

class DetailActionSection extends StatelessWidget {
  const DetailActionSection({
    super.key,
    this.onEdit,
    this.onDuplicate,
    this.onArchive,
    this.onDelete,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onArchive;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Actions",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            _ActionTile(
              icon: Icons.edit_outlined,
              title: "Edit Habit",
              color: Colors.blue,
              onTap: onEdit,
            ),
            _ActionTile(
              icon: Icons.copy_outlined,
              title: "Duplicate Habit",
              color: Colors.green,
              onTap: onDuplicate,
            ),
            _ActionTile(
              icon: Icons.archive_outlined,
              title: "Archive Habit",
              color: Colors.orange,
              onTap: onArchive,
            ),
            _ActionTile(
              icon: Icons.delete_outline,
              title: "Delete Habit",
              color: Colors.red,
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: .12),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
