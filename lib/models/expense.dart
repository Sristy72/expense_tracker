import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

final uuid = Uuid();
enum Category {food, travel, leisure, work} //enum is a keyword that allows us to create a custom type
final categoryIcon = {
  Category.food : Icons.lunch_dining,
  Category.travel : Icons.flight_takeoff,
  Category.leisure : Icons.movie,
  Category.work : Icons.work
};

class Expense{
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category
  })
      : id = uuid.v4();//In dart, "initializer lists" can be used to initialize class
// properties like "id" with values that are not received as constructor function arguments.

}

class ExpenseBucket{
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)//extra construction function
      : expenses = allExpense
            .where((expense) => expense.category == category)
            .toList();

  double get totalExpenses{
    double sum = 0;
    for(final expense in expenses){
      sum += expense.amount;
    }
    return sum;
  }
}