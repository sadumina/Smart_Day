import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/task.dart';
import '../../../features/tasks/providers/task_providers.dart';
import '../../../shared/widgets/empty_state.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(todayTasksProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(error.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (items) {
          final tasksByDay = _groupByDay(items);
          final selectedTasks = tasksByDay[_dateKey(_selectedDay)] ?? [];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: TableCalendar<Task>(
                  firstDay: DateTime.utc(2020),
                  lastDay: DateTime.utc(2035),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                  eventLoader: (day) => tasksByDay[_dateKey(day)] ?? [],
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                  calendarStyle: CalendarStyle(
                    markerDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Tasks for ${_selectedDay.day}/${_selectedDay.month}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (selectedTasks.isEmpty)
                const EmptyState(
                  title: 'No tasks scheduled',
                  message: 'Choose another day or add a due date to a task.',
                  icon: Icons.event_available_outlined,
                )
              else
                ...selectedTasks.map(
                  (task) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      task.status == 'done'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                    ),
                    title: Text(task.title),
                    subtitle: Text(task.priority.name.toUpperCase()),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Map<String, List<Task>> _groupByDay(List<Task> tasks) {
    final result = <String, List<Task>>{};
    for (final task in tasks) {
      final dueAt = task.dueAt;
      if (dueAt == null) continue;
      result.putIfAbsent(_dateKey(dueAt), () => []).add(task);
    }
    return result;
  }

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
