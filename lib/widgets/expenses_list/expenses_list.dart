import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({required this.expensesList, super.key, required this.onRemoveSaveExpenses});
  final Function(Expense expense) onRemoveSaveExpenses;

  final List<Expense> expensesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expensesList.length,
      itemBuilder: (context, index) => Dismissible(
          key: ValueKey(expensesList[index]),
          background: Container(
            color: Theme.of(context).colorScheme.error.withValues(alpha: .75),
            margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          onDismissed: (direction){onRemoveSaveExpenses(expensesList[index]);},
          child: ExpenseItem(expense: expensesList[index]),),
    );
  }
}
