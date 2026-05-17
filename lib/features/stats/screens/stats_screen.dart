import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/daily_entry.dart';
import '../../../features/daily_input/providers/daily_input_provider.dart';
import '../widgets/streak_card.dart';
import '../widgets/stats_summary_card.dart';
import '../widgets/most_consumed_pie_chart.dart';
import '../widgets/score_trend_line_chart.dart';

final statsDataProvider = FutureProvider.autoDispose<List<DailyEntry>>((ref) async {
  final repo = ref.read(dailyRepositoryProvider);
  final entries = await repo.getAllEntries();
  return entries;
});

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(statsDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        animateColor: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(statsDataProvider.future),
          ),
        ],
      ),
      body: statsAsync.when(
        data: (entries) => RefreshIndicator(
          onRefresh: () => ref.refresh(statsDataProvider.future),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreakCard(entries: entries),
                const SizedBox(height: 24),
                StatsSummaryCard(entries: entries),
                const SizedBox(height: 32),

                const Text("Most Logged Food Groups", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 100),
                SizedBox(height: 500, child: MostConsumedPieChart(entries: entries)),

                const SizedBox(height: 40),

                const Text("Score Trend (Last 30 Days)", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Padding(padding: const EdgeInsets.all(16),child: SizedBox(height: 240, child: ScoreTrendLineChart(entries: entries))),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Failed to load statistics")),
      ),
    );
  }
}