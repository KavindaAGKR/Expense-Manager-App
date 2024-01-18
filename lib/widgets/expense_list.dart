// import 'package:expense_tracker/models/expense.dart';
// import 'package:expense_tracker/widgets/expense_tile.dart';
// import 'package:flutter/material.dart';

// class ExpenseList extends StatelessWidget {
//   final List<Expense> expenseList;

//   final Function(Expense expense) onDeleteExpense;

//   const ExpenseList(
//       {super.key, required this.expenseList, required this.onDeleteExpense});

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: expenseList.length,
//         itemBuilder: (BuildContext context, int index) {
//           return Dismissible(
//               key: ValueKey(expenseList[index]),
//               direction: DismissDirection.startToEnd,
//               onDismissed: (direction) {
//                 onDeleteExpense(expenseList[index]);
//               },
//               child: ExpenseTile(expense: expenseList[index]));
//         },
//       ),
//     );
//   }
// }

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_tile.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final void Function(Expense expense) onDeleteExpense;
  final List<Expense> expenseList;
  // final Function(Expense expense) onDeleteExpense;

  const ExpenseList({
    Key? key,
    required this.expenseList,
    required this.onDeleteExpense,

    //  required this.onDeleteExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: expenseList.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ValueKey(expenseList[index]),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            onDeleteExpense(expenseList[index]);
          },
          child: ExpenseTile(expense: expenseList[index]),
        );
      },
    );
  }
}
