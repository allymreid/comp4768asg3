import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expenseProvider).expenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              context.go('/charts/bar'); // example chart route
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add'),
        child: const Icon(Icons.add),
      ),
      body: expenses.isEmpty
          ? const Center(child: Text('No expenses added yet.'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                final key = expense.key as int;

                return Dismissible(
                  key: Key(key.toString()),
                  background: Container(color: Colors.red),
                  onDismissed: (_) {
                    ref.read(expenseProvider).deleteExpense(key);
                  },
                  child: ListTile(
                    title: Text(expense.name),
                    subtitle: Text('${expense.amount.toStringAsFixed(2)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => context.go('/edit/$key'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
