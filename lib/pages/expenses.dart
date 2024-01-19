import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/server/database.dart';
import 'package:expense_tracker/widgets/add_new_expense.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key}) : super(key: key);

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final _myBox = Hive.box("expenseDatabase");
  late Database db;

  @override
  void initState() {
    super.initState();
    db = Database();

    // If this is the first time, create the initial database
    if (_myBox.get("EXP_DATA") == null) {
      db.createInitialDatabase();
    } else {
      db.loadData();
    }
  }

  void onAddNewExpense(Expense expense) {
    setState(() {
      db.expenseList.add(expense);
    });
    db.updateData();
  }

  void onDeleteExpense(Expense expense) {
    Expense deletingExpense = expense;
    // Get the index of the removing expense
    final int deletingIndex = db.expenseList.indexOf(expense);

    setState(() {
      db.expenseList.remove(expense);
      db.updateData();
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Delete Successful"),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            db.expenseList.insert(deletingIndex, deletingExpense);
            db.updateData();
          });
        },
      ),
    ));
  }

  // void _openAddExpensesOverlay() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return AddNewExpense(
  //         onAddExpense: onAddNewExpense,
  //       );
  //     },
  //     isScrollControlled: true,
  //   );
  // }
  void _openAddExpensesOverlay() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: AddNewExpense(
              onAddExpense: onAddNewExpense,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalExpense = db.expenseList.isNotEmpty
        ? db.expenseList
            .map((expense) => expense.amount)
            .reduce((a, b) => a + b)
        : 0.0;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 227, 227),
      body: Column(
        children: [
          Container(
            color: Color.fromARGB(255, 0, 0, 0),
            height: 100,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin:
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
            height: 170,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Color.fromARGB(223, 241, 173, 13),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Total Expense: \Rs. ${totalExpense.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Today is : ',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        DateTime.now().toString().substring(0, 10),
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          const Text(
            'Expense History',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              decoration: TextDecoration.underline,
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromARGB(255, 249, 213, 239),
              child: ExpenseList(
                expenseList: db.expenseList,
                onDeleteExpense: onDeleteExpense,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FloatingActionButton(
                  onPressed: _openAddExpensesOverlay,
                  child: const Icon(Icons.add),
                  backgroundColor: Color.fromARGB(255, 255, 162, 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1000.0),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
