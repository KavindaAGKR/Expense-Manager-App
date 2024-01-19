import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 147, 149, 153),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  expense.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('Rs ' + expense.amount.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expense.getFormatedDate,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: CategoryColors[expense.category],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(' ' +
                          expense.category.toString().split('.').last +
                          ' '),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Description: '),
                    Text(
                      expense.description,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
