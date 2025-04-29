import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {

  final List<Expense> _newExpenses = [
    Expense(
        title: 'Laptop',
        amount: 23,
        date: DateTime.now(),
        category: Category.leisure),

    Expense(
        title: 'Laptop',
        amount: 23,
        date: DateTime.now(),
        category: Category.leisure),
  ];


  _openAddExpenseOverlay(){
    showModalBottomSheet(
      useSafeArea: true,
        isScrollControlled: true,
        context: context/*this context for Expense widget*/,
        builder: (ctx/*this context for showModalBottomSheet*/) => NewExpense(onAddNewExpenses: _saveNewExpenses,));
  }
  _saveNewExpenses(Expense expense){
    setState(() {
      _newExpenses.add(expense);
    });
  }
  _removeSavedExpenses(Expense expense){
      final removedExpenseIndex = _newExpenses.indexOf(expense);
    setState(() {
      _newExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Text('${expense.title} deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _newExpenses.insert(removedExpenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if(_newExpenses.isNotEmpty){
      mainContent = ExpensesList(expensesList: _newExpenses, onRemoveSaveExpenses: _removeSavedExpenses);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text('Flutter Expense Tracker'),
        actions: [
          IconButton(onPressed: _openAddExpenseOverlay, icon: Icon(Icons.add))
        ],
      ),
      body: width < 600 ? Column(
        children: [
          Chart(expenses: _newExpenses),
          Expanded(child: mainContent)
        ],
      ) : Row(
        children: [
          Expanded(child: Chart(expenses: _newExpenses)),
          Expanded(child: mainContent)
        ],
      ),
    );
  }
}
