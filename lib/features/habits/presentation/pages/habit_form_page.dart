import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/cards/cards.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../../domain/models/habit_form_arguments.dart';
import '../provider/habit_form_provider.dart';

import '../sections/habit_appearance_section.dart';
import '../sections/habit_basic_information_section.dart';
import '../sections/habit_preview_section.dart';
import '../sections/habit_schedule_section.dart';

import '../widgets/save_habit_button.dart';

class HabitFormPage extends ConsumerStatefulWidget {
  const HabitFormPage({
    super.key,
    this.arguments,
  });

  final HabitFormArguments? arguments;

  @override
  ConsumerState<HabitFormPage> createState() => _HabitFormPageState();
}

class _HabitFormPageState extends ConsumerState<HabitFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  late final FocusNode _titleFocus;
  late final FocusNode _descriptionFocus;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = widget.arguments;

      if (args == null) return;

      final notifier = ref.read(habitFormProvider.notifier);

      if (args.isDuplicating) {
        notifier.duplicateFrom(args.habit!);
      } else if (args.isEditing) {
        notifier.loadFromHabit(args.habit!);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    _titleFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(habitFormProvider);

    return form.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(
            error.toString(),
          ),
        ),
      ),
      data: (state) {
        // Keep controllers synchronized with provider.
        if (_titleController.text != state.title) {
          _titleController.value = TextEditingValue(
            text: state.title,
            selection: TextSelection.collapsed(
              offset: state.title.length,
            ),
          );
        }

        if (_descriptionController.text != state.description) {
          _descriptionController.value = TextEditingValue(
            text: state.description,
            selection: TextSelection.collapsed(
              offset: state.description.length,
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              state.isEditing ? 'Edit Habit' : 'Create Habit',
            ),
          ),
          body: SafeArea(
            child: ResponsiveLayout(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //----------------------------------------------------
                      // Basic Information
                      //----------------------------------------------------

                      HabitBasicInformationSection(
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        titleFocusNode: _titleFocus,
                        descriptionFocusNode: _descriptionFocus,
                      ),

                      const SizedBox(
                        height: AppSpacing.lg,
                      ),

                      //----------------------------------------------------
                      // Appearance
                      //----------------------------------------------------

                      const HabitAppearanceSection(),

                      const SizedBox(
                        height: AppSpacing.lg,
                      ),

                      //----------------------------------------------------
                      // Schedule
                      //----------------------------------------------------

                      const HabitScheduleSection(),

                      const SizedBox(
                        height: AppSpacing.lg,
                      ),

                      //----------------------------------------------------
                      // Live Preview
                      //----------------------------------------------------

                      const HabitPreviewSection(),

                      const SizedBox(
                        height: AppSpacing.xl,
                      ),

                      //----------------------------------------------------
                      // Save Button
                      //----------------------------------------------------

                      SaveHabitButton(
                        formKey: _formKey,
                      ),

                      //----------------------------------------------------
                      // Validation Error
                      //----------------------------------------------------

                      if (state.error != null) ...[
                        const SizedBox(
                          height: AppSpacing.lg,
                        ),
                        ErrorCard(
                          message: state.error!,
                        ),
                      ],

                      const SizedBox(
                        height: AppSpacing.xxl,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
