import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user_profile.dart';
import '../providers/profile_provider.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({
    super.key,
  });

  @override
  ConsumerState<EditProfilePage> createState() {
    return _EditProfilePageState();
  }
}

class _EditProfilePageState
    extends ConsumerState<EditProfilePage> {
  final _nameController =
  TextEditingController();

  bool _initialized = false;

  bool _notificationsEnabled = false;

  final List<String> _selectedGoals = [];

  static const List<String> _availableGoals = [
    'Health',
    'Fitness',
    'Productivity',
    'Learning',
    'Mindfulness',
  ];

  @override
  void dispose() {
    _nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final profile =
    ref.watch(profileProvider);

    return profile.when(
      loading: () {
        return const Scaffold(
          body: Center(
            child:
            CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) {
        return Scaffold(
          body: Center(
            child: Text(
              error.toString(),
            ),
          ),
        );
      },
      data: (user) {
        if (!_initialized) {
          _initialized = true;

          _nameController.text = user.name;

          _notificationsEnabled =
              user.notificationsEnabled;

          _selectedGoals.clear();

          _selectedGoals.addAll(
            user.goals,
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Edit Profile',
            ),
          ),
          body: ListView(
            padding:
            const EdgeInsets.all(16),
            children: [
              TextField(
                controller:
                _nameController,
                decoration:
                const InputDecoration(
                  labelText: 'Name',
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              Text(
                'Goals',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),

              const SizedBox(
                height: 12,
              ),

              Wrap(
                spacing: 8,
                children:
                _availableGoals.map(
                      (goal) {
                    final selected =
                    _selectedGoals
                        .contains(
                      goal,
                    );

                    return FilterChip(
                      label: Text(
                        goal,
                      ),
                      selected:
                      selected,
                      onSelected:
                          (value) {
                        setState(() {
                          if (value) {
                            _selectedGoals
                                .add(
                              goal,
                            );
                          } else {
                            _selectedGoals
                                .remove(
                              goal,
                            );
                          }
                        });
                      },
                    );
                  },
                ).toList(),
              ),

              const SizedBox(
                height: 24,
              ),

              SwitchListTile(
                title: const Text(
                  'Notifications',
                ),
                value:
                _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled =
                        value;
                  });
                },
              ),

              const SizedBox(
                height: 32,
              ),

              FilledButton(
                onPressed: () async {

                  final updated = user.copyWith(
                    name: _nameController.text,
                    goals: List<String>.from(
                      _selectedGoals,
                    ),
                    notificationsEnabled:
                    _notificationsEnabled,
                  );

                  await ref
                      .read(
                    profileProvider
                        .notifier,
                  )
                      .updateProfile(
                    updated,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  'Save',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}