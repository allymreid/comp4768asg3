import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

class AddEditScreen extends ConsumerStatefulWidget {
  final int? expenseKey;
  const AddEditScreen({super.key, this.expenseKey});

  @override
  ConsumerState<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends ConsumerState<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food'; // default
  final categories = ['Food', 'Transport', 'Shopping', 'Entertainment', 'Utility', 'Education', 'Other'];

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expenseKey != null) {
      final existing = ref.read(expenseProvider).getExpenseByKey(widget.expenseKey!);
      if (existing != null) {
        _nameController.text = existing.description;
        _amountController.text = existing.amount.toString();
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      final newExpense = Expense(
        description: name,
        amount: amount,
        date: _selectedDate,
        category: _selectedCategory
      );

      if (widget.expenseKey != null) {
        ref.read(expenseProvider).updateExpense(widget.expenseKey!, newExpense);
      } else {
        ref.read(expenseProvider).addExpense(newExpense);
      }

      context.go('/');
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseKey != null ? 'Edit Expense' : 'Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final val = double.tryParse(value ?? '');
                  if (val == null || val <= 0) return 'Enter a valid amount';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: 'Category'),
              ),

              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Date'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${_selectedDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),


              const Spacer(),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
