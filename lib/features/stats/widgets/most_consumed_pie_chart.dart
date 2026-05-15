import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../data/models/daily_entry.dart';
import '../../../data/models/food_groups.dart';

class MostConsumedPieChart extends StatelessWidget {
  final List<DailyEntry> entries;

  const MostConsumedPieChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Center(child: Text("No data yet"));
    }

    // Aggregate servings
    final Map<String, int> totalServings = {};
    for (var entry in entries) {
      entry.servings.forEach((groupId, count) {
        totalServings[groupId] = (totalServings[groupId] ?? 0) + count;
      });
    }

    if (totalServings.isEmpty) {
      return const Center(child: Text("No food groups logged yet"));
    }

    final sorted = totalServings.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topGroups = sorted.take(5).toList();

    final List<PieChartSectionData> sections = [];
    final List<Widget> legendItems = [];

    for (var entry in topGroups) {
      final foodGroup = allFoodGroups.firstWhere(
        (g) => g.id == entry.key,
        orElse: () => FoodGroup(
          id: entry.key,
          name: entry.key,
          category: FoodCategory.adequacy,
          emoji: '❓',
          servingHint: '',
        ),
      );

      final total = totalServings.values.reduce((a, b) => a + b);
      final percentage = (entry.value / total) * 100;

      final color = Colors.primaries[topGroups.indexOf(entry) % Colors.primaries.length];

      sections.add(
        PieChartSectionData(
          value: entry.value.toDouble(),
          title: foodGroup.emoji,
          color: color,
          radius: 100,
          titleStyle: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          badgeWidget: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          badgePositionPercentageOffset: 1.3,
        ),
      );

      legendItems.add(
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(foodGroup.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(foodGroup.name, style: const TextStyle(fontSize: 14)),
            ),
            Text("${entry.value}×", style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Pie Chart - Reduced height to prevent overflow
        SizedBox(
          height: 240,                    // Reduced from 260
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 45,
              sectionsSpace: 3,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Legend
        const Text(
          "Legend",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...legendItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: item,
            )),
      ],
    );
  }
}