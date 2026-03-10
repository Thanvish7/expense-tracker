import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/newexpense.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<StatefulWidget> createState() {
    return _Expensestate();
  }
}

class _Expensestate extends State<Expenses> {
  final List<Expense> _registeredexpsense = [
    Expense(
      title: 'cinema',
      amount: 20,
      date: DateTime.now(),
      category: Category.entertainment,
    ),
    Expense(
      title: 'course',
      amount: 15,
      date: DateTime.now(),
      category: Category.study,
    ),
  ];

  final Map<Category, Color> categoryColors = {
    Category.place: Colors.blue,
    Category.food: Colors.red,
    Category.travel: Colors.green,
    Category.entertainment: Colors.orange,
    Category.study: Colors.purple,
  };

  List<PieChartSectionData> getPieSections() {
    return Category.values
        .map((category) {
          final bucket = expensebucket.getcategory(
            _registeredexpsense,
            category,
          );
          if (bucket.totalsum == 0) return null;
          return PieChartSectionData(
            value: bucket.totalsum,
            title: '${category.name}\n\$${bucket.totalsum.toStringAsFixed(0)}',
            color: categoryColors[category],
            radius: 100,
            titleStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        })
        .where((section) => section != null)
        .cast<PieChartSectionData>()
        .toList();
  }

  void _openadd() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctxt) => Newexpense(addexpense: addnewexpense),
    );
  }

  void addnewexpense(Expense ex) {
    setState(() {
      _registeredexpsense.add(ex);
    });
  }

  void removeexpense(Expense ex) {
    final exindex = _registeredexpsense.indexOf(ex);
    setState(() {
      _registeredexpsense.remove(ex);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        persist: false,
        content: Text("expense deleted"),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            setState(() {
              _registeredexpsense.insert(exindex, ex);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget maincontent = Center(
      child: Text("no expense found start adding some"),
    );

    if (_registeredexpsense.isNotEmpty) {
      maincontent = ExpensesList(
        expenses: _registeredexpsense,
        expenseremover: removeexpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("EXPENSE TRACKER"),
        actions: [IconButton(onPressed: _openadd, icon: Icon(Icons.add))],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: getPieSections().isEmpty
                ? Center(child: Text("no data to display"))
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: getPieSections(),
                    ),
                  ),
          ),
          Expanded(child: maincontent),
        ],
      ),
    );
  }
}