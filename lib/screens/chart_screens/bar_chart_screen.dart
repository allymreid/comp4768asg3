import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/expense_provider.dart';
import 'package:go_router/go_router.dart';

class BarChartScreen extends ConsumerWidget {
  const BarChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider).expenses;

    final Map<String, double> totals = {};
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }

    final labels = totals.keys.toList();
    final values = totals.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bar Chart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: expenses.isEmpty
            ? const Center(child: Text('No data'))
            : BarChart(
                BarChartData(
                  barGroups: List.generate(values.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(toY: values[i], width: 16),
                      ],
                    );
                  }),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          if (value.toInt() >= labels.length) return const SizedBox.shrink();
                          return Text(labels[value.toInt()], style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
