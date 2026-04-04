import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/categories.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../logic/transaction_bloc/transaction_bloc.dart';
import '../../../../logic/transaction_bloc/transaction_event.dart';

class AddEditTransactionSheet extends StatefulWidget {
  const AddEditTransactionSheet({
    super.key,
    this.transaction,
  });

  final TransactionModel? transaction;

  @override
  State<AddEditTransactionSheet> createState() => _AddEditTransactionSheetState();
}

class _AddEditTransactionSheetState extends State<AddEditTransactionSheet> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _type = 'expense';
  String? _category;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _amountError;
  String? _categoryError;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final tx = widget.transaction!;
      _amountController.text = tx.amount.toStringAsFixed(0);
      _noteController.text = tx.note ?? '';
      _type = tx.type;
      _category = tx.category;
      _date = tx.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _amountError = null;
      _categoryError = null;
    });
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      setState(() => _amountError = 'Amount must be greater than 0');
      return;
    }
    if (_category == null) {
      setState(() => _categoryError = 'Select a category');
      return;
    }

    setState(() => _saving = true);
    final now = DateTime.now();
    final bloc = context.read<TransactionBloc>();

    if (widget.transaction == null) {
      final tx = TransactionModel();
      tx.uuid = const Uuid().v4();
      tx.amount = amount;
      tx.type = _type;
      tx.category = _category!;
      tx.date = DateHelpers.normalizeDate(_date);
      tx.note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
      tx.createdAt = now;
      tx.updatedAt = now;
      tx.isSeeded = false;
      bloc.add(AddTransaction(tx));
    } else {
      final tx = widget.transaction!;
      tx.amount = amount;
      tx.type = _type;
      tx.category = _category!;
      tx.date = DateHelpers.normalizeDate(_date);
      tx.note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();
      tx.updatedAt = now;
      bloc.add(UpdateTransaction(tx));
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.transaction == null ? 'Transaction added' : 'Transaction updated'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEdit ? 'Edit transaction' : 'Add transaction',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixText: '₹ ',
                errorText: _amountError,
                hintText: '0',
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'income', label: Text('Income')),
                ButtonSegment(value: 'expense', label: Text('Expense')),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() => _type = value.first),
            ),
            const SizedBox(height: 16),
            Text('Category', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Categories.all
                  .map(
                    (cat) => InkWell(
                      onTap: () => setState(() => _category = cat.key),
                      child: Container(
                        width: 72,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _category == cat.key
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).dividerColor,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Icon(cat.icon, color: cat.color, size: 20),
                            const SizedBox(height: 4),
                            Text(cat.label, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (_categoryError != null) ...[
              const SizedBox(height: 4),
              Text(_categoryError!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() => _date = picked);
                }
              },
              child: Text('Date: ${_date.day}/${_date.month}/${_date.year}'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Add a note...'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator())
                    : Text(isEdit ? 'Update' : 'Save'),
              ),
            ),
            if (isEdit) ...[
              TextButton(
                onPressed: () {
                  context.read<TransactionBloc>().add(DeleteTransaction(widget.transaction!.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Transaction deleted'),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}