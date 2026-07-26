import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/utils/csv_export.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense_sheet.dart';
import 'package:expense_tracker/widgets/summary_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      title: 'Cinema',
      amount: 20,
      date: DateTime.now(),
      category: Category.entertainment,
    ),
    Expense(
      title: 'Flutter Course',
      amount: 15,
      date: DateTime.now(),
      category: Category.study,
    ),
  ];

  final Map<Category, Color> _categoryColors = {
    Category.place: Colors.blue,
    Category.food: Colors.red,
    Category.travel: Colors.green,
    Category.entertainment: Colors.orange,
    Category.study: Colors.purple,
  };

  // ── Chart ──────────────────────────────────────────────────────────────────

  List<PieChartSectionData> _getPieSections() {
    return Category.values
        .map((category) {
          final bucket = ExpenseBucket.forCategory(_expenses, category);
          if (bucket.totalSum == 0) return null;
          return PieChartSectionData(
            value: bucket.totalSum,
            title:
                '${category.name}\n\$${bucket.totalSum.toStringAsFixed(0)}',
            color: _categoryColors[category],
            radius: 90,
            titleStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        })
        .whereType<PieChartSectionData>()
        .toList();
  }

  // ── Sheet helpers ──────────────────────────────────────────────────────────

  void _openAddSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NewExpenseSheet(onSaveExpense: _addExpense),
    );
  }

  void _openEditSheet(Expense expense) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => NewExpenseSheet(
        onSaveExpense: _updateExpense,
        existingExpense: expense,
      ),
    );
  }

  // ── CRUD ───────────────────────────────────────────────────────────────────

  void _addExpense(Expense expense) {
    setState(() => _expenses.add(expense));
  }

  void _updateExpense(Expense updated) {
    setState(() {
      final index = _expenses.indexWhere((e) => e.id == updated.id);
      if (index != -1) _expenses[index] = updated;
    });
  }

  void _removeExpense(Expense expense) {
    final index = _expenses.indexOf(expense);
    setState(() => _expenses.remove(expense));

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: const Text('Expense deleted'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () =>
                setState(() => _expenses.insert(index, expense)),
          ),
        ),
      );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final sections = _getPieSections();

    return Scaffold(
      appBar: AppBar(
        title: const Text('EXPENSE TRACKER'),
        actions: [
          // Export CSV
          IconButton(
            tooltip: 'Export CSV',
            icon: const Icon(Icons.download_outlined),
            onPressed: () => exportToCsv(context, _expenses),
          ),
          // Add expense
          IconButton(
            tooltip: 'Add expense',
            icon: const Icon(Icons.add),
            onPressed: _openAddSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Pie chart ────────────────────────────────────────────────────
          SizedBox(
            height: 260,
            width: double.infinity,
            child: sections.isEmpty
                ? const Center(child: Text('No data to display'))
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 36,
                      sections: sections,
                    ),
                  ),
          ),

          // ── Summary card ─────────────────────────────────────────────────
          SummaryCard(expenses: _expenses),

          // ── List hint ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '${_expenses.length} expense${_expenses.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  '← swipe to delete   swipe → to edit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          // ── Expenses list ────────────────────────────────────────────────
          Expanded(
            child: _expenses.isEmpty
                ? const Center(
                    child: Text('No expenses yet — tap + to add one!'),
                  )
                : ExpensesList(
                    expenses: _expenses,
                    onRemoveExpense: _removeExpense,
                    onEditExpense: _openEditSheet,
                  ),
          ),
        ],
      ),
    );
  }
}
