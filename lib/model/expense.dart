import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum Category { place, food, travel, entertainment, study }

const Categoryicons = {
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

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formatteddate {
    return formatter.format(date);
  }
}

class expensebucket {
  expensebucket({required this.category, required this.expenses});

  expensebucket.getcategory(List<Expense> allexpense, this.category)
    : expenses = allexpense
          .where((expense) => expense.category == category)
          .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalsum {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
