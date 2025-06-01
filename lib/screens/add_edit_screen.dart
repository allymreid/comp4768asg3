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
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.expenseKey != null) {
      final existing = ref.read(expenseProvider).getExpenseByKey(widget.expenseKey!);
      if (existing != null) {
        _nameController.text = existing.name;
        _amountController.text = existing.amount.toString();
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final amount = double.parse(_amountController.text.trim());

      final newExpense = Expense(
        name: name,
        amount: amount,
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
              ElevatedButton(
                onPressed: _pickDate,
                child: Text('Pick Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
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
