import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';

class Expenses extends StatefulWidget {
  // this is class widget class
  const Expenses({super.key});
  // this is a constructor function (const constructor)
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  // this is a state class which extends from widget class

  final List<Expense> _regesteredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      // keeps app not overlapping with device features such as battery, camera etc
      isScrollControlled: true,
      // it keeps keyboard below the entries of new expense
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
      // context is the context of class and ctx is the context of "showModalBottomSheet"
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _regesteredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _regesteredExpenses.indexOf(expense);
    setState(() {
      _regesteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    // it removes all messages on screen. So after removing all then only new message will come
    ScaffoldMessenger.of(context).showSnackBar(
      // all the ScaffoldMessnger thing is for undoing a delete
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense added.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _regesteredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // basically we check the width so as to check if we have enought width to put chart and list items in a row in landscape mode
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_regesteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _regesteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter ExpenseTracker'), actions: [
        IconButton(
          onPressed: _openAddExpenseOverlay,
          icon: Icon(Icons.add),
        )
      ]),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _regesteredExpenses),
                Expanded(
                  // we used Expanded because we are inside a acolumn and in "ExpensesList" we are using a ListView() which is like another column. Column inside column creates a problem
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  // It constraints the child(i.e Chart) to only take as much width as available in the row after sizing the other Row children
                  child: Chart(expenses: _regesteredExpenses),
                  // Bascially if we did'nt use expanded then this Chart takes all width of row and we don't see anything on screen as it has a property of infinity set by us in its file
                ),
                Expanded(
                  // we used Expanded because we are inside a acolumn and in "ExpensesList" we are using a ListView() which is like another column. Column inside column creates a problem
                  child: mainContent,
                ),
              ],
            ),
    );
    // Scaffold does style setup and adds bg color
  }
}
