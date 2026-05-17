import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../data/models/daily_entry.dart';

class ScoreTrendLineChart extends StatelessWidget {
  final List<DailyEntry> entries;

  const ScoreTrendLineChart({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return const Center(
        child: Text("Log more days to see the trend"),
      );
    }

    final sortedEntries = entries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final spots = sortedEntries.asMap().entries.map((e) {
      final index = e.key;        
      final entry = e.value;
      return FlSpot(
        (index + 1).toDouble(), 
        entry.score.toDouble(),
      );
    }).toList();

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final day = value.toInt();
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Day $day',
                    style: const TextStyle(fontSize: 11),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 25,
              maxIncluded: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            preventCurveOverShooting: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: .1),
            ),
          ),
        ],
        minX: 1,              
        maxX: spots.length.toDouble(),
        minY: 0,
        maxY: 100,
      ),
    );
  }
}