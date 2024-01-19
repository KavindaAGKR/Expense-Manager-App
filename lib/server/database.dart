import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:hive/hive.dart';

class Database {
  //create a database reference
  final _myBox = Hive.box("expenseDatabase");

  List<Expense> expenseList = [];

  List<Income> incomeList = [];

  //create init expense list function
  void createInitialDatabase() {
    expenseList = [
      Expense(
          name: "name",
          amount: 12.4,
          dateTime: DateTime.now(),
          category: Category.clothes,
          description: "Description"),
      Expense(
          name: "name",
          amount: 12.4,
          dateTime: DateTime.now(),
          category: Category.clothes,
          description: "Description"),
      Expense(
          name: "name",
          amount: 12.4,
          dateTime: DateTime.now(),
          category: Category.clothes,
          description: "Description"),
    ];

    incomeList = [
      Income(name: "Icncome1", amount: 500000),
      Income(name: "Income2", amount: 350000),
    ];
  }

  //load the database
  void loadData() {
    final dynamic data = _myBox.get("EXP_DATA");

    //validate data
    if (data != null && data is List<dynamic>) {
      expenseList = data.cast<Expense>().toList();
      //incomeList = data.cast<Income>().toList();
    }

    final dynamic incomeData = _myBox.get("INC_DATA");

    // Validate income data
    if (incomeData != null && incomeData is List<dynamic>) {
      incomeList = incomeData.cast<Income>().toList();
    }
  }

  //update the data
  Future<void> updateData() async {
    await _myBox.put(
      "EXP_DATA",
      expenseList,
    );
   // await _myBox.put("EXP_DATA", incomeList);
  }

  Future<void> updateIncomeData() async {
    await _myBox.put(
      "INC_DATA",
      incomeList,
    );
  }
}
