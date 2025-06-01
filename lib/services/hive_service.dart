import 'package:hive/hive.dart';
import '../models/expense.dart';

class HiveService {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenses');

  List<Expense> getAllExpenses() {
    return _expenseBox.values.toList();
  }

  Future<void> addExpense(Expense expense) async {
    await _expenseBox.add(expense);
  }

  Future<void> updateExpense(int key, Expense updatedExpense) async {
    await _expenseBox.put(key, updatedExpense);
  }

  Future<void> deleteExpense(int key) async {
    await _expenseBox.delete(key);
  }

  Expense? getExpenseByKey(int key) {
    return _expenseBox.get(key);
  }
}
