import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrisense/features/daily_input/providers/daily_input_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/daily_entry.dart';

final calendarEntriesProvider = FutureProvider<Map<DateTime, DailyEntry>>((ref) async {
  final repo = ref.read(dailyRepositoryProvider);
  final entries = await repo.getAllEntries();
  return {for (var e in entries) DateTime(e.date.year, e.date.month, e.date.day): e};
});

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(calendarEntriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('History'), animateColor: true),
      body: entriesAsync.when(
        data: (entries) => TableCalendar<DailyEntry>(
          firstDay: DateTime.now().subtract(const Duration(days: 400)),
          lastDay: DateTime.now().add(const Duration(days: 30)),
          focusedDay: DateTime.now(),
          eventLoader: (date) => entries.containsKey(date) ? [entries[date]!] : [],
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: const CalendarStyle(
            markersMaxCount: 1,
            markerDecoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle),
          ),
          onDaySelected: (selectedDay, focusedDay) {
            ref.invalidate(currentDailyEntryProvider(selectedDay));
            context.push('/daily?date=${selectedDay.toIso8601String()}');
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Failed to load history')),
      ),
    );
  }
}