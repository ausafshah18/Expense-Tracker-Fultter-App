// this file is a model (like a blueprint) for expenses
import 'package:uuid/uuid.dart'; // for dynamically generating id's for each expense
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // for date formatting

final formatter = DateFormat.yMd();

const uuid = Uuid();

enum Category { food, travel, leisure, work }
// enum allows us to create a custom type

const categoryIcons = {
  // it is an icon map
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();
  // using this uuid package a unique id is generate as string for each expense
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  // DateTime is a DataType which allows us to put date in a single vlaue
  final Category category;

  String get formattedDate {
    //it is a getter
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      // this is additional category
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();
  // we are checking if the expense category has the same category as the bucket then it is kept

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
