import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.expenseremover,
  });

  final List<Expense> expenses;
  final Function(Expense expense) expenseremover;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctxt, index) => Dismissible(
        background: Container(
          color: Theme.of(context).colorScheme.errorContainer,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
        onDismissed: (direction) {
          expenseremover(expenses[index]);
        },
        key: ValueKey(expenses[index]),
        child: Column(
          children: [
            ExpenseItem(expenses[index]),
          ],
        ),
      ),
    );
  }
}
