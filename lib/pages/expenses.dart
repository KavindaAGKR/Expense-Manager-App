import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/server/database.dart';
import 'package:expense_tracker/widgets/add_new_expense.dart';
import 'package:expense_tracker/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final _myBox = Hive.box("expenseDatabase");
  Database db = Database();
  // final List<Expense> expenseList = [
  //   // Expense(
  //   //     name: "name",
  //   //     amount: 12.4,
  //   //     dateTime: DateTime.now(),
  //   //     category: Category.apparel),
  //   // Expense(
  //   //     name: "name",
  //   //     amount: 12.4,
  //   //     dateTime: DateTime.now(),
  //   //     category: Category.apparel),
  //   // Expense(
  //   //     name: "name",
  //   //     amount: 12.4,
  //   //     dateTime: DateTime.now(),
  //   //     category: Category.apparel),
  // ];

  void onAddNewExpense(Expense expense) {
    setState(() {
      db.expenseList.add(expense);
    });
    db.updateData();
  }

  void onDeleteExpense(Expense expense) {
    Expense deletingExpense = expense;
    //get the index of the removing iexpense
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
          }),
    ));
  }

  @override
  void initState() {
    super.initState();

    //if this is the first time create the initial database
    if (_myBox.get("EXP_DATA") == null) {
      db.createInitialDatabase();
    } else
      db.loadData();

    //prepare data on startup
    // Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  //void onAddNewExpense(Expense expense) {}

  void _openAddExpensesOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddNewExpense(
          onAddExpense: onAddNewExpense,
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
      // appBar: AppBar(
      //     // title: const Text("Expenses"),
      //     ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),

          //   child: Text(
          //     'Total Expense: \Rs. ${totalExpense.toStringAsFixed(2)}',
          //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          //   ),
          // ),
          Container(
            color: const Color.fromARGB(255, 87, 87, 87),
            height: 100,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Expense Manager',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 239, 247, 88)),
              ),
            ),
          ),

          Container(
            height: 170,
            width: double.infinity,
            //color: const Color.fromARGB(255, 119, 119, 119),
            child: Container(
              margin: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 20),
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Total Expense: \Rs. ${totalExpense.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Today is : ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          DateTime.now().toString().substring(0, 10),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,

                            //fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Text(
            'Expense History',
            style: TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 20,
              decoration: TextDecoration.underline,

              //fontWeight: FontWeight.bold
            ),
          ),

          Expanded(
            child: ExpenseList(
              expenseList: db.expenseList,
              onDeleteExpense: onDeleteExpense,
            ),
          ),

          //Text("Add a new Expense", style: TextStyle(fontSize: 15),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  onPressed: _openAddExpensesOverlay,
                  child: const Icon(Icons.add),
                  backgroundColor: Color.fromARGB(255, 239, 231, 3),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

//   ListView _expenseList() {
//     return ListView.separated(
//       itemCount: _expenseModel.expenses.length,
//       separatorBuilder: (context, index) => const SizedBox(
//         height: 15,
//       ),
//       itemBuilder: (context, index) {
//         return Dismissible(
//             key: ValueKey(_expenseModel.expenses[index]),
//             direction: DismissDirection.startToEnd,
//             onDismissed: (direction) {},
//             child: ExpenseTile(expense: _expenseModel.expenses[index]));
//       },
//     );
//   }
// }
}
