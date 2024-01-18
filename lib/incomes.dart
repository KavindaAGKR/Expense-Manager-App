import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/server/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Incomes extends StatefulWidget {
  const Incomes({Key? key}) : super(key: key);

  @override
  State<Incomes> createState() => _CategoriesState();
}

class _CategoriesState extends State<Incomes> {
  // final IncomeModel _incomeModel = IncomeModel();

  final _myBox = Hive.box("expenseDatabase");
  Database db = Database();

  final newIncome = TextEditingController();
  final newAmount = TextEditingController();

  void _addIncome() {
    setState(() {
      db.incomeList.add(
          Income(name: newIncome.text, amount: double.parse(newAmount.text)));
      db.updateIncomeData();
      newIncome.clear();
      newAmount.clear();
    });
  }

  @override
  void initState() {
    super.initState();

    //if this is the first time create the initial database
    if (_myBox.get("INC_DATA") == null) {
      db.createInitialDatabase();
    } else
      db.loadData();

    //prepare data on startup
    // Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addIncome() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // title: Text("Add Income"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newIncome,
              decoration: const InputDecoration(
                hintText: "Add new income",
                label: Text("Title"),
              ),
              keyboardType: TextInputType.text,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter amount",
                label: Text("Amount"),
              ),
              controller: newAmount,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _addIncome(); // Add the category
            },
            child: const Text("Add"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deleteIncome() {}
  double calculateTotalIncome() {
    double totalIncome = 0.0;

    for (var income in db.incomeList) {
      totalIncome += income.amount;
    }

    return totalIncome;
  }

  @override
  Widget build(BuildContext context) {
    // _getInitInfo();
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              'Total Income:\Rs.${calculateTotalIncome().toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: _incomeList(),
      floatingActionButton: FloatingActionButton(
        onPressed: addIncome,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void onDeleteIncome(Income income) {
    Income deletingIncome = income;
    final int deletingIndex = db.incomeList.indexOf(income);

    setState(() {
      db.incomeList.remove(income);
      db.updateIncomeData();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("Delete Successful"),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              db.incomeList.insert(deletingIndex, deletingIncome);
              db.updateIncomeData();
            });
          }),
    ));
  }

  ListView _incomeList() {
    return ListView.separated(
      itemCount: db.incomeList.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(db.incomeList[index]),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            onDeleteIncome(db.incomeList[index]);
          },
          child: Container(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(db.incomeList[index].name.toString()),
                  Text(db.incomeList[index].amount.toString()),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      color: Color(0xff1D1617).withOpacity(0.07),
                      offset: Offset(0, 10),
                      blurRadius: 40,
                      spreadRadius: 0)
                ]),
          ),
        );
      },
    );
  }
}
