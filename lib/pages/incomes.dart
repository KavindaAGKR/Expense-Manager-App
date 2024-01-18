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

    if (_myBox.get("INC_DATA") == null) {
      db.createInitialDatabase();
    } else
      db.loadData();
  }

  void addIncome() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
              Navigator.of(context).pop();
              _addIncome();
            },
            child: const Text("Add"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
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

  double calculateTotalIncome() {
    double totalIncome = 0.0;

    for (var income in db.incomeList) {
      totalIncome += income.amount;
    }

    return totalIncome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                  top: 20, left: 10, right: 10, bottom: 20),
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
                    'Total Income : \Rs ${calculateTotalIncome().toStringAsFixed(2)}',
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
            'Income History',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: _incomeList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addIncome,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
            height: 75,
            width: 20,
            child: Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    db.incomeList[index].name.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Rs ' + db.incomeList[index].amount.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 170, 167, 167),
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
