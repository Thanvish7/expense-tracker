import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { place, food, travel, entertainment, study }

const categoryIcons = {
  Category.food: Icons.food_bank_rounded,
  Category.place: Icons.place,
  Category.travel: Icons.travel_explore_outlined,
  Category.entertainment: Icons.movie,
  Category.study: Icons.school,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  // Constructor for editing — preserves the original id
  Expense.withId({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate => formatter.format(date);
}

class ExpenseBucket {
  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalSum =>
      expenses.fold(0, (sum, expense) => sum + expense.amount);
}
