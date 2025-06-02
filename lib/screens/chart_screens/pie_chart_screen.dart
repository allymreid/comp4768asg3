import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/expense_provider.dart';

class PieChartScreen extends ConsumerWidget {
  const PieChartScreen({super.key});
  
Color categoryColor(String category) {
  switch (category) {
    case 'Food':
      return Colors.green;
    case 'Transport':
      return Colors.blue;
    case 'Shopping':
      return Colors.purple;
    case 'Entertainment':
      return Colors.orange;
    case 'Utilities':
      return Colors.red;
    case 'Education':
      return Colors.teal;
    default:
      return Colors.grey;
  }
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider).expenses;

    final Map<String, double> totals = {};
    for (var e in expenses) {
      totals[e.category] = (totals[e.category] ?? 0) + e.amount;
    }

    final sections = totals.entries.map((entry) {
      return PieChartSectionData(
        title: entry.key,
        value: entry.value,
        color: categoryColor(entry.key),
        radius: 60,
        titleStyle: const TextStyle(fontSize: 18, color: Colors.white),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pie Chart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: expenses.isEmpty
            ? const Center(child: Text('No data'))
            : PieChart(PieChartData(sections: sections)),
      ),
    );
  }
}
