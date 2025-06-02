import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/expense_provider.dart';

class LineChartScreen extends ConsumerWidget {
  const LineChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider).expenses;

    expenses.sort((a, b) => a.date.compareTo(b.date));
    final points = List.generate(expenses.length, (i) {
      return FlSpot(i.toDouble(), expenses[i].amount);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Line Chart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: expenses.isEmpty
            ? const Center(child: Text('No data'))
            : LineChart(
                LineChartData(
                  minY: 0, // Ensure y-axis starts at 0
                  lineBarsData: [
                    LineChartBarData(
                      spots: points,
                      isCurved: true,
                      barWidth: 2,
                      dotData: FlDotData(show: true),
                    )
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          int index = value.toInt();
                          if (index < 0 || index >= expenses.length) return const SizedBox.shrink();
                          final date = expenses[index].date;
                          final formatted = '${date.month}/${date.day}';
                          return Text(formatted, style: const TextStyle(fontSize: 10));
                        },

                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
      ),
    );
  }
}
