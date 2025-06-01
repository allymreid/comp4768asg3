import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseNotifier extends ChangeNotifier {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseNotifier() {
    loadExpenses();
  }

  void loadExpenses() {
    _expenses = _expenseBox.values.toList();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await _expenseBox.add(expense);
    loadExpenses();
  }

  Future<void> updateExpense(int key, Expense expense) async {
    await _expenseBox.put(key, expense);
    loadExpenses();
  }

  Future<void> deleteExpense(int key) async {
    await _expenseBox.delete(key);
    loadExpenses();
  }

  Expense? getExpenseByKey(int key) {
    return _expenseBox.get(key);
  }
}

final expenseProvider = ChangeNotifierProvider<ExpenseNotifier>((ref) {
  return ExpenseNotifier();
});
