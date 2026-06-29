import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const storageKey = 'streak-calculator-state';
const defaultPointsPerTask = 100;
const categories = ['Health', 'Study', 'Work', 'Personal'];

void main() {
  runApp(const StreakCalculatorApp());
}

class StreakCalculatorApp extends StatelessWidget {
  const StreakCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streak Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.blue),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const StreakHomePage(),
    );
  }
}

class StreakHomePage extends StatefulWidget {
  const StreakHomePage({super.key});

  @override
  State<StreakHomePage> createState() => _StreakHomePageState();
}

class _StreakHomePageState extends State<StreakHomePage> {
  AppState? state;
  final taskNameController = TextEditingController();
  final defaultPointsController = TextEditingController();
  final taskPointsController = TextEditingController();
  String selectedCategory = categories.first;
  bool includeNewTaskInStreak = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  @override
  void dispose() {
    taskNameController.dispose();
    defaultPointsController.dispose();
    taskPointsController.dispose();
    super.dispose();
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(storageKey);
    final loaded = AppState.fromSavedJson(saved);

    setState(() {
      state = loaded;
      defaultPointsController.text = loaded.pointsPerTask.toString();
      taskPointsController.text = loaded.pointsPerTask.toString();
    });
  }

  Future<void> _saveAndRender(AppState next) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(storageKey, jsonEncode(next.toJson()));
    if (mounted) {
      setState(() => state = next);
    }
  }

  void _setSelectedDate(DateTime date) {
    final next = state!.copyWith(selectedDate: dateKey(date));
    _saveAndRender(next);
  }

  void _setDefaultPoints(String value) {
    final points = normalizePoints(value);
    final next = state!.copyWith(pointsPerTask: points);
    defaultPointsController.text = points.toString();
    if (taskPointsController.text.trim().isEmpty) {
      taskPointsController.text = points.toString();
    }
    _saveAndRender(next);
  }

  void _resetDefaultPoints() {
    defaultPointsController.text = defaultPointsPerTask.toString();
    taskPointsController.text = defaultPointsPerTask.toString();
    _saveAndRender(state!.copyWith(pointsPerTask: defaultPointsPerTask));
  }

  void _addTask() {
    final name = taskNameController.text.trim();
    if (name.isEmpty) return;

    final nextTasks = [
      ...state!.tasks,
      StreakTask(
        id: UniqueKey().toString(),
        name: name,
        category: selectedCategory,
        points: normalizePoints(taskPointsController.text),
        includeInStreak: includeNewTaskInStreak,
        history: {},
      ),
    ];

    taskNameController.clear();
    taskPointsController.text = state!.pointsPerTask.toString();
    _saveAndRender(state!.copyWith(tasks: nextTasks));
  }

  void _toggleTask(StreakTask task) {
    final selected = state!.selectedDate;
    final history = Map<String, bool>.from(task.history);
    if (history[selected] == true) {
      history.remove(selected);
    } else {
      history[selected] = true;
    }
    _replaceTask(task.copyWith(history: history));
  }

  void _deleteTask(StreakTask task) {
    _saveAndRender(
      state!.copyWith(
          tasks: state!.tasks.where((item) => item.id != task.id).toList()),
    );
  }

  void _updateTaskPoints(StreakTask task, String value) {
    _replaceTask(task.copyWith(points: normalizePoints(value)));
  }

  void _replaceTask(StreakTask updated) {
    _saveAndRender(
      state!.copyWith(
        tasks: state!.tasks
            .map((task) => task.id == updated.id ? updated : task)
            .toList(),
      ),
    );
  }

  void _clearCompleted() {
    final selected = state!.selectedDate;
    final nextTasks = state!.tasks.map((task) {
      final history = Map<String, bool>.from(task.history)..remove(selected);
      return task.copyWith(history: history);
    }).toList();
    _saveAndRender(state!.copyWith(tasks: nextTasks));
  }

  @override
  Widget build(BuildContext context) {
    final current = state;
    if (current == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final metrics = Metrics.fromState(current);

    return Scaffold(
      backgroundColor: AppColors.page,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  HeaderSection(
                    state: current,
                    defaultPointsController: defaultPointsController,
                    onDateChanged: _setSelectedDate,
                    onDefaultPointsChanged: _setDefaultPoints,
                    onResetDefaultPoints: _resetDefaultPoints,
                  ),
                  const SizedBox(height: 16),
                  MetricsGrid(metrics: metrics),
                  const SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 900;
                      final taskPanel = TaskPanel(
                        state: current,
                        taskNameController: taskNameController,
                        taskPointsController: taskPointsController,
                        selectedCategory: selectedCategory,
                        includeNewTaskInStreak: includeNewTaskInStreak,
                        onCategoryChanged: (value) =>
                            setState(() => selectedCategory = value),
                        onIncludeNewTaskChanged: (value) =>
                            setState(() => includeNewTaskInStreak = value),
                        onAddTask: _addTask,
                        onClearCompleted: _clearCompleted,
                        onToggleTask: _toggleTask,
                        onDeleteTask: _deleteTask,
                        onTaskPointsChanged: _updateTaskPoints,
                      );
                      final chartPanel =
                          ChartPanel(state: current, metrics: metrics);

                      if (!wide) {
                        return Column(
                          children: [
                            taskPanel,
                            const SizedBox(height: 16),
                            chartPanel,
                          ],
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 6, child: taskPanel),
                          const SizedBox(width: 16),
                          Expanded(flex: 4, child: chartPanel),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  HistoryPanel(state: current),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    required this.state,
    required this.defaultPointsController,
    required this.onDateChanged,
    required this.onDefaultPointsChanged,
    required this.onResetDefaultPoints,
    super.key,
  });

  final AppState state;
  final TextEditingController defaultPointsController;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onDefaultPointsChanged;
  final VoidCallback onResetDefaultPoints;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 760;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Eyebrow('Daily Streak Dashboard'),
            SizedBox(height: 8),
            Text(
              'Build repeatable days, one checkmark at a time.',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 40,
                height: 1,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        );
        final controls = Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: narrow ? double.infinity : 190,
              child: DateControl(
                selectedDate: parseLocalDate(state.selectedDate),
                onDateChanged: onDateChanged,
              ),
            ),
            SizedBox(
              width: narrow ? double.infinity : 220,
              child: PointsControl(
                controller: defaultPointsController,
                onChanged: onDefaultPointsChanged,
                onReset: onResetDefaultPoints,
              ),
            ),
          ],
        );

        if (narrow) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(height: 18),
                controls,
              ]);
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: title),
            const SizedBox(width: 24),
            controls,
          ],
        );
      },
    );
  }
}

class DateControl extends StatelessWidget {
  const DateControl(
      {required this.selectedDate, required this.onDateChanged, super.key});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ControlLabel('Plan date'),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) onDateChanged(picked);
          },
          icon: const Icon(Icons.calendar_today_outlined, size: 18),
          label: Text(dateKey(selectedDate)),
          style: outlinedButtonStyle,
        ),
      ],
    );
  }
}

class PointsControl extends StatelessWidget {
  const PointsControl({
    required this.controller,
    required this.onChanged,
    required this.onReset,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ControlLabel('Default points'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: controller,
                keyboardType: TextInputType.number,
                onSubmitted: onChanged,
                onEditingComplete: () => onChanged(controller.text),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 46,
              child: OutlinedButton(
                  onPressed: onReset,
                  style: outlinedButtonStyle,
                  child: const Text('Reset')),
            ),
          ],
        ),
      ],
    );
  }
}

class MetricsGrid extends StatelessWidget {
  const MetricsGrid({required this.metrics, super.key});

  final Metrics metrics;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Total tasks', metrics.totalTasks.toString(), AppColors.ink),
      ('Done today', metrics.doneToday.toString(), AppColors.ink),
      ('Streak points', metrics.streakPoints.toString(), AppColors.green),
      ('Completion', '${metrics.completionRate}%', AppColors.ink),
      (
        'Best streak',
        '${metrics.bestStreak} ${metrics.bestStreak == 1 ? 'day' : 'days'}',
        AppColors.ink
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 560
            ? 2
            : constraints.maxWidth < 900
                ? 3
                : 5;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 112,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return AppPanel(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.$1, style: mutedBold),
                  const SizedBox(height: 8),
                  Text(
                    item.$2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: item.$3,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class TaskPanel extends StatelessWidget {
  const TaskPanel({
    required this.state,
    required this.taskNameController,
    required this.taskPointsController,
    required this.selectedCategory,
    required this.includeNewTaskInStreak,
    required this.onCategoryChanged,
    required this.onIncludeNewTaskChanged,
    required this.onAddTask,
    required this.onClearCompleted,
    required this.onToggleTask,
    required this.onDeleteTask,
    required this.onTaskPointsChanged,
    super.key,
  });

  final AppState state;
  final TextEditingController taskNameController;
  final TextEditingController taskPointsController;
  final String selectedCategory;
  final bool includeNewTaskInStreak;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<bool> onIncludeNewTaskChanged;
  final VoidCallback onAddTask;
  final VoidCallback onClearCompleted;
  final ValueChanged<StreakTask> onToggleTask;
  final ValueChanged<StreakTask> onDeleteTask;
  final void Function(StreakTask task, String value) onTaskPointsChanged;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PanelHeading(
            eyebrow: 'Today',
            title: 'Tasks',
            trailing: OutlinedButton(
                onPressed: onClearCompleted,
                style: outlinedButtonStyle,
                child: const Text('Clear done')),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 620;
              final nameField = AppTextField(
                controller: taskNameController,
                hintText: 'Add a task, habit, or routine',
                maxLength: 48,
                onSubmitted: (_) => onAddTask(),
              );
              final fields = [
                nameField,
                SizedBox(
                  width: narrow ? double.infinity : 140,
                  child: AppDropdown(
                      value: selectedCategory, onChanged: onCategoryChanged),
                ),
                SizedBox(
                  width: narrow ? double.infinity : 118,
                  child: AppTextField(
                      controller: taskPointsController,
                      keyboardType: TextInputType.number),
                ),
                SizedBox(
                  width: narrow ? double.infinity : 168,
                  height: 46,
                  child: IncludeInStreakControl(
                    value: includeNewTaskInStreak,
                    onChanged: onIncludeNewTaskChanged,
                  ),
                ),
                SizedBox(
                  width: narrow ? double.infinity : 86,
                  height: 46,
                  child: FilledButton(
                      onPressed: onAddTask,
                      style: filledButtonStyle,
                      child: const Text('Add')),
                ),
              ];

              if (narrow) {
                return Column(
                  children: fields
                      .map((field) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: field))
                      .toList(),
                );
              }

              return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: fields[0]),
                    const SizedBox(width: 10),
                    fields[1],
                    const SizedBox(width: 10),
                    fields[2],
                    const SizedBox(width: 10),
                    fields[3],
                    const SizedBox(width: 10),
                    fields[4],
                  ]);
            },
          ),
          const SizedBox(height: 16),
          if (state.tasks.isEmpty)
            const EmptyState()
          else
            ...state.tasks.map((task) {
              final done = task.history[state.selectedDate] == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TaskTile(
                  task: task,
                  done: done,
                  currentStreak: task.includeInStreak
                      ? currentStreak(task, state.selectedDate)
                      : 0,
                  onToggle: () => onToggleTask(task),
                  onDelete: () => onDeleteTask(task),
                  onPointsChanged: (value) => onTaskPointsChanged(task, value),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.done,
    required this.currentStreak,
    required this.onToggle,
    required this.onDelete,
    required this.onPointsChanged,
    super.key,
  });

  final StreakTask task;
  final bool done;
  final int currentStreak;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final ValueChanged<String> onPointsChanged;

  @override
  Widget build(BuildContext context) {
    final pointsController =
        TextEditingController(text: task.points.toString());
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 42,
            height: 42,
            child: IconButton.filledTonal(
              onPressed: onToggle,
              icon: Icon(Icons.check,
                  color: done ? Colors.white : Colors.transparent),
              style: IconButton.styleFrom(
                backgroundColor: done ? AppColors.green : Colors.white,
                side:
                    BorderSide(color: done ? AppColors.green : AppColors.line),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, color: AppColors.ink)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Chip(
                      label: Text(task.category),
                      side: BorderSide.none,
                      visualDensity: VisualDensity.compact,
                      backgroundColor: AppColors.page,
                    ),
                    Text(
                      task.includeInStreak
                          ? '$currentStreak day streak'
                          : 'Excluded from streak',
                      style: mutedBold.copyWith(fontSize: 12),
                    ),
                    SizedBox(
                      width: 146,
                      child: Row(
                        children: [
                          Text('Points',
                              style: mutedBold.copyWith(fontSize: 12)),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SizedBox(
                              height: 34,
                              child: AppTextField(
                                controller: pointsController,
                                keyboardType: TextInputType.number,
                                onSubmitted: onPointsChanged,
                                onEditingComplete: () =>
                                    onPointsChanged(pointsController.text),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.close),
            color: AppColors.coral,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }
}

class IncludeInStreakControl extends StatelessWidget {
  const IncludeInStreakControl({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(!value),
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: (next) => onChanged(next ?? true),
              visualDensity: VisualDensity.compact,
              activeColor: AppColors.green,
            ),
            const Flexible(
              child: Text(
                'Count streak',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColors.muted,
                    fontWeight: FontWeight.w800,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartPanel extends StatelessWidget {
  const ChartPanel({required this.state, required this.metrics, super.key});

  final AppState state;
  final Metrics metrics;

  @override
  Widget build(BuildContext context) {
    final days = lastDays(state.selectedDate, 7);
    final streakTasks =
        state.tasks.where((task) => task.includeInStreak).toList();
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeading(eyebrow: 'Progress', title: '7-day completion'),
          Wrap(
            spacing: 18,
            runSpacing: 18,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CompletionDonut(rate: metrics.completionRate),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LegendItem(color: AppColors.green, label: 'Completed'),
                  SizedBox(height: 10),
                  LegendItem(color: AppColors.track, label: 'Remaining'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: days.map((date) {
                final done = streakTasks
                    .where((task) => task.history[date] == true)
                    .length;
                final rate = streakTasks.isEmpty
                    ? 0
                    : ((done / streakTasks.length) * 100).round();
                return Expanded(child: CompletionBar(date: date, rate: rate));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class CompletionDonut extends StatelessWidget {
  const CompletionDonut({required this.rate, super.key});

  final int rate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: DonutPainter(rate: rate),
        child: Center(
          child: Text('$rate%',
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        ),
      ),
    );
  }
}

class DonutPainter extends CustomPainter {
  DonutPainter({required this.rate});

  final int rate;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2;
    final trackPaint = Paint()..color = AppColors.track;
    final donePaint = Paint()..color = AppColors.green;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
        rect, -math.pi / 2, (rate / 100) * math.pi * 2, true, donePaint);
    canvas.drawCircle(center, radius - 18, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) =>
      oldDelegate.rate != rate;
}

class CompletionBar extends StatelessWidget {
  const CompletionBar({required this.date, required this.rate, super.key});

  final String date;
  final int rate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: math.max(rate, 3) / 100,
                widthFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColors.blue, AppColors.green],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(formatShortDay(date), style: mutedBold.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class HistoryPanel extends StatelessWidget {
  const HistoryPanel({required this.state, super.key});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PanelHeading(eyebrow: 'Streak marks', title: 'Task history'),
          if (state.tasks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No tasks yet.', style: mutedBold),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: mutedBold.copyWith(fontSize: 12),
                dataTextStyle: const TextStyle(
                    color: AppColors.ink, fontWeight: FontWeight.w700),
                columns: const [
                  DataColumn(label: Text('Task')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Streak')),
                  DataColumn(label: Text('Task points')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Earned today')),
                  DataColumn(label: Text('Current streak')),
                  DataColumn(label: Text('Best streak')),
                  DataColumn(label: Text('Last 7 days')),
                ],
                rows: state.tasks.map((task) {
                  final done = task.history[state.selectedDate] == true;
                  return DataRow(cells: [
                    DataCell(Text(task.name)),
                    DataCell(Text(task.category)),
                    DataCell(
                        Text(task.includeInStreak ? 'Included' : 'Excluded')),
                    DataCell(Text(task.points.toString())),
                    DataCell(StatusPill(done: done)),
                    DataCell(Text(
                        (done && task.includeInStreak ? task.points : 0)
                            .toString())),
                    DataCell(Text(
                        '${task.includeInStreak ? currentStreak(task, state.selectedDate) : 0} days')),
                    DataCell(Text(
                        '${task.includeInStreak ? calculateBestStreak(task) : 0} days')),
                    DataCell(
                        Marks(task: task, selectedDate: state.selectedDate)),
                  ]);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class Marks extends StatelessWidget {
  const Marks({required this.task, required this.selectedDate, super.key});

  final StreakTask task;
  final String selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: lastDays(selectedDate, 7).map((date) {
        final done = task.history[date] == true;
        return Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(right: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done ? AppColors.greenSoft : AppColors.page,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            done ? '✓' : '·',
            style: TextStyle(
              color: done
                  ? AppColors.green
                  : AppColors.muted.withValues(alpha: 0.7),
              fontWeight: FontWeight.w900,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({required this.done, super.key});

  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: done ? AppColors.greenSoft : AppColors.page,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        done ? 'Completed' : 'Pending',
        style: TextStyle(
            color: done ? AppColors.green : AppColors.muted,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  const LegendItem({required this.color, required this.label, super.key});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 8),
        Text(label, style: mutedBold),
      ],
    );
  }
}

class PanelHeading extends StatelessWidget {
  const PanelHeading(
      {required this.eyebrow, required this.title, this.trailing, super.key});

  final String eyebrow;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Eyebrow(eyebrow),
                const SizedBox(height: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel(
      {required this.child,
      this.padding = const EdgeInsets.all(20),
      super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        border: Border.all(color: AppColors.line.withValues(alpha: 0.9)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1A1C273A), blurRadius: 45, offset: Offset(0, 18))
        ],
      ),
      child: child,
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.maxLength,
    this.onSubmitted,
    this.onEditingComplete,
    super.key,
  });

  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        onSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: outlineBorder,
          focusedBorder: outlineBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.blue)),
        ),
      ),
    );
  }
}

class AppDropdown extends StatelessWidget {
  const AppDropdown({required this.value, required this.onChanged, super.key});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          enabledBorder: outlineBorder,
          focusedBorder: outlineBorder.copyWith(
              borderSide: const BorderSide(color: AppColors.blue)),
        ),
        items: categories
            .map((category) =>
                DropdownMenuItem(value: category, child: Text(category)))
            .toList(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Add your first daily task to start tracking streaks.',
        textAlign: TextAlign.center,
        style: mutedBold,
      ),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          color: AppColors.blue, fontSize: 12, fontWeight: FontWeight.w900),
    );
  }
}

class ControlLabel extends StatelessWidget {
  const ControlLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: mutedBold);
}

class AppState {
  const AppState({
    required this.selectedDate,
    required this.pointsPerTask,
    required this.tasks,
  });

  final String selectedDate;
  final int pointsPerTask;
  final List<StreakTask> tasks;

  factory AppState.fromSavedJson(String? saved) {
    if (saved == null) return seededState();
    try {
      final parsed = jsonDecode(saved) as Map<String, dynamic>;
      final points = normalizePoints(parsed['pointsPerTask']);
      final parsedTasks = parsed['tasks'];
      return AppState(
        selectedDate: parsed['selectedDate'] as String? ?? todayKey(),
        pointsPerTask: points,
        tasks: parsedTasks is List
            ? parsedTasks
                .map((item) =>
                    StreakTask.fromJson(item as Map<String, dynamic>, points))
                .toList()
            : starterTasks(),
      );
    } catch (_) {
      return seededState();
    }
  }

  Map<String, dynamic> toJson() => {
        'selectedDate': selectedDate,
        'pointsPerTask': pointsPerTask,
        'tasks': tasks.map((task) => task.toJson()).toList(),
      };

  AppState copyWith(
      {String? selectedDate, int? pointsPerTask, List<StreakTask>? tasks}) {
    return AppState(
      selectedDate: selectedDate ?? this.selectedDate,
      pointsPerTask: pointsPerTask ?? this.pointsPerTask,
      tasks: tasks ?? this.tasks,
    );
  }
}

class StreakTask {
  const StreakTask({
    required this.id,
    required this.name,
    required this.category,
    required this.points,
    required this.includeInStreak,
    required this.history,
  });

  final String id;
  final String name;
  final String category;
  final int points;
  final bool includeInStreak;
  final Map<String, bool> history;

  factory StreakTask.fromJson(Map<String, dynamic> json, int fallbackPoints) {
    final parsedHistory = json['history'];
    return StreakTask(
      id: json['id'] as String? ?? UniqueKey().toString(),
      name: json['name'] as String? ?? 'Untitled task',
      category: json['category'] as String? ?? categories.first,
      points: normalizePoints(json['points'] ?? fallbackPoints),
      includeInStreak: json['includeInStreak'] as bool? ?? true,
      history: parsedHistory is Map
          ? parsedHistory
              .map((key, value) => MapEntry(key.toString(), value == true))
          : <String, bool>{},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'points': points,
        'includeInStreak': includeInStreak,
        'history': history,
      };

  StreakTask copyWith(
      {int? points, bool? includeInStreak, Map<String, bool>? history}) {
    return StreakTask(
      id: id,
      name: name,
      category: category,
      points: points ?? this.points,
      includeInStreak: includeInStreak ?? this.includeInStreak,
      history: history ?? this.history,
    );
  }
}

class Metrics {
  const Metrics({
    required this.totalTasks,
    required this.doneToday,
    required this.streakPoints,
    required this.completionRate,
    required this.bestStreak,
  });

  final int totalTasks;
  final int doneToday;
  final int streakPoints;
  final int completionRate;
  final int bestStreak;

  factory Metrics.fromState(AppState state) {
    final streakTasks =
        state.tasks.where((task) => task.includeInStreak).toList();
    final done = streakTasks
        .where((task) => task.history[state.selectedDate] == true)
        .length;
    final points = streakTasks.fold<int>(
      0,
      (sum, task) =>
          sum + (task.history[state.selectedDate] == true ? task.points : 0),
    );
    return Metrics(
      totalTasks: state.tasks.length,
      doneToday: done,
      streakPoints: points,
      completionRate:
          streakTasks.isEmpty ? 0 : ((done / streakTasks.length) * 100).round(),
      bestStreak: streakTasks.fold<int>(
          0, (max, task) => math.max(max, calculateBestStreak(task))),
    );
  }
}

AppState seededState() {
  final tasks = starterTasks();
  seedStarterHistory(tasks);
  return AppState(
      selectedDate: todayKey(),
      pointsPerTask: defaultPointsPerTask,
      tasks: tasks);
}

List<StreakTask> starterTasks() => [
      StreakTask(
        id: UniqueKey().toString(),
        name: 'Morning workout',
        category: 'Health',
        points: defaultPointsPerTask,
        includeInStreak: true,
        history: {},
      ),
      StreakTask(
        id: UniqueKey().toString(),
        name: 'Read 20 pages',
        category: 'Study',
        points: defaultPointsPerTask,
        includeInStreak: true,
        history: {},
      ),
      StreakTask(
        id: UniqueKey().toString(),
        name: 'Plan tomorrow',
        category: 'Work',
        points: defaultPointsPerTask,
        includeInStreak: true,
        history: {},
      ),
    ];

void seedStarterHistory(List<StreakTask> tasks) {
  final days = lastDays(todayKey(), 7);
  for (var taskIndex = 0; taskIndex < tasks.length; taskIndex += 1) {
    final history = tasks[taskIndex].history;
    for (var dayIndex = 0; dayIndex < days.length; dayIndex += 1) {
      if ((dayIndex + taskIndex) % 3 != 1) {
        history[days[dayIndex]] = true;
      }
    }
  }
}

int currentStreak(StreakTask task, String fromDate) {
  var streak = 0;
  var cursor = parseLocalDate(fromDate);

  while (task.history[dateKey(cursor)] == true) {
    streak += 1;
    cursor = cursor.subtract(const Duration(days: 1));
  }

  return streak;
}

int calculateBestStreak(StreakTask task) {
  final dates = task.history.entries
      .where((entry) => entry.value)
      .map((entry) => entry.key)
      .toList()
    ..sort();
  var best = 0;
  var current = 0;
  String? previous;

  for (final date in dates) {
    if (previous == null || dayDiff(previous, date) == 1) {
      current += 1;
    } else {
      current = 1;
    }
    best = math.max(best, current);
    previous = date;
  }

  return best;
}

List<String> lastDays(String date, int count) {
  final parsed = parseLocalDate(date);
  return List.generate(count, (index) {
    return dateKey(parsed.subtract(Duration(days: count - index - 1)));
  });
}

int dayDiff(String first, String second) {
  return parseLocalDate(second).difference(parseLocalDate(first)).inDays;
}

int normalizePoints(dynamic value) {
  final points = int.tryParse(value.toString()) ?? defaultPointsPerTask;
  return points.clamp(1, 10000).toInt();
}

String todayKey() => dateKey(DateTime.now());

String dateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

DateTime parseLocalDate(String date) {
  final parts = date.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

String formatShortDay(String date) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return labels[parseLocalDate(date).weekday - 1];
}

const outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(8)),
  borderSide: BorderSide(color: AppColors.line),
);

final outlinedButtonStyle = OutlinedButton.styleFrom(
  minimumSize: const Size(0, 46),
  foregroundColor: AppColors.muted,
  side: const BorderSide(color: AppColors.line),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  textStyle: const TextStyle(fontWeight: FontWeight.w800),
);

final filledButtonStyle = FilledButton.styleFrom(
  backgroundColor: AppColors.ink,
  foregroundColor: Colors.white,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  textStyle: const TextStyle(fontWeight: FontWeight.w800),
);

const mutedBold =
    TextStyle(color: AppColors.muted, fontWeight: FontWeight.w800);

class AppColors {
  static const ink = Color(0xFF18202F);
  static const muted = Color(0xFF697386);
  static const line = Color(0xFFD9E0EA);
  static const page = Color(0xFFEEF4F8);
  static const green = Color(0xFF1F9D68);
  static const greenSoft = Color(0xFFDFF5EA);
  static const coral = Color(0xFFEF6B5A);
  static const blue = Color(0xFF2C7BE5);
  static const track = Color(0xFFE6EDF4);
}
