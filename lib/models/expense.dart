import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'expense.g.dart';

class ExpenseModel extends ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }
}

enum Category {
  food,
  travel,
  leasure,
  work,
  health,
  education,
  transportation,
  apparel
}

//category icons
final CategoryColors = {
  Category.food: const Color.fromARGB(255, 8, 91, 236),
  Category.travel: Color.fromARGB(165, 2, 222, 98),
  Category.leasure: Colors.pinkAccent,
  Category.work: Color.fromARGB(249, 255, 255, 54),
  Category.health: const Color.fromARGB(255, 124, 122, 120),
  Category.education: Color.fromARGB(255, 0, 166, 160),
  Category.transportation: Colors.indigoAccent,
  Category.apparel: Color.fromARGB(255, 171, 2, 174),
};

// final CategoryColor = {
//   Category.food : Icons.abc,
//   Category.travel,
//   Category.leasure,
//   Category.work,
//   Category.health,
//   Category.education,
//   Category.transportation,
//   Category.apparel,
// };

final formattedDate = DateFormat.yMd();

@HiveType(typeId: 1)
class Expense {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime dateTime;

  @HiveField(3)
  final Category category;

  @HiveField(4)
  final String description;

  Expense({
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.category,
    required this.description,
  });

  String get getFormatedDate {
    return formattedDate.format(dateTime);
  }
}
