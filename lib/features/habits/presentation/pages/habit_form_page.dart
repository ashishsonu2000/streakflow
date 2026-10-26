import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/ui/cards/cards.dart';
import '../../../../shared/ui/layouts/layouts.dart';

import '../../domain/models/habit_form_arguments.dart';

import '../provider/habit_form_provider.dart';
import '../sections/habit_appearance_section.dart';
import '../sections/habit_basic_information_section.dart';
import '../sections/habit_ideas_section.dart';
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

  /// The floating save button slides away while scrolling down, so it
  /// does not cover controls on the right (switches, + buttons).
  bool _showSaveButton = true;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) {
      return false;
    }

    bool? show;

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse) {
        show = false;
      } else if (notification.direction == ScrollDirection.forward) {
        show = true;
      }
    }

    // Always bring it back at the end of the form.
    if (notification.metrics.extentAfter == 0) {
      show = true;
    }

    if (show != null && show != _showSaveButton) {
      setState(() => _showSaveButton = show!);
    }

    return false;
  }

  @override
  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();

    Future.microtask(() async {
      final args = widget.arguments;

      if (args == null) {
        return;
      }

      // The form provider builds asynchronously; when this page is the
      // first form opened since launch it is still loading here, and
      // loading the habit would throw (blank "Create Habit" form).
      await ref.read(habitFormProvider.future);

      if (!mounted) {
        return;
      }

      final notifier = ref.read(habitFormProvider.notifier);

      if (args.isDuplicating && args.habit != null) {
        notifier.duplicateFrom(args.habit!);
      } else if (args.isEditing && args.habit != null) {
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
              state.isEditing ? 'Edit Habit' : 'Add Habit',
            ),
          ),
          //--------------------------------------------------------
          // Save Button: floats over the form; slides away while
          // scrolling down and is hidden while the keyboard is open,
          // so it never covers what the user is working on.
          //--------------------------------------------------------

          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: MediaQuery.viewInsetsOf(context).bottom > 0
              ? null
              : IgnorePointer(
                  ignoring: !_showSaveButton,
                  child: AnimatedSlide(
                    offset: _showSaveButton ? Offset.zero : const Offset(0, 2),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: SaveHabitButton(
                      formKey: _formKey,
                    ),
                  ),
                ),
          body: SafeArea(
            child: ResponsiveLayout(
              child: Form(
                key: _formKey,
                child: NotificationListener<ScrollNotification>(
                  onNotification: _onScroll,
                  child: SingleChildScrollView(
                    padding: AppSpacing.screenPadding,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        //----------------------------------------------------
                        // Basic Information
                        //----------------------------------------------------

                        // Ideas only for a brand-new habit (not when
                        // editing or duplicating).
                        if (!state.isEditing &&
                            widget.arguments?.isDuplicating != true) ...[
                          const HabitIdeasSection(),
                          const SizedBox(
                            height: AppSpacing.lg,
                          ),
                        ],

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

                        // Room for the floating save button.
                        const SizedBox(
                          height: 110,
                        ),
                      ],
                    ),
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
