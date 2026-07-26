import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.onEditExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(Expense expense) onEditExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        final expense = expenses[index];
        return Dismissible(
          background: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            color: Theme.of(context).colorScheme.errorContainer,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          secondaryBackground: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Theme.of(context).colorScheme.primaryContainer,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              onRemoveExpense(expense);
            } else {
              // Swipe right-to-left = edit
              // Re-insert immediately and open edit sheet
              onEditExpense(expense);
            }
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              onEditExpense(expense);
              return false; // Don't actually dismiss — just trigger edit
            }
            return true;
          },
          key: ValueKey(expense.id),
          child: ExpenseItem(expense),
        );
      },
    );
  }
}
