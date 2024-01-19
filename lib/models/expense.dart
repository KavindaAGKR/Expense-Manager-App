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
  leisure,
  work,
  health,
  education,
  transportation,
  clothes
}

//category icons
final CategoryColors = {
  Category.food: const Color.fromARGB(255, 8, 91, 236),
  Category.travel: Color.fromARGB(248, 2, 203, 106),
  Category.leisure: Color.fromARGB(255, 238, 24, 96),
  Category.work: Color.fromARGB(248, 246, 246, 0),
  Category.health: Color.fromARGB(255, 168, 84, 0),
  Category.education: Color.fromARGB(255, 164, 51, 220),
  Category.transportation: Color.fromARGB(255, 76, 76, 76),
  Category.clothes: Color.fromARGB(255, 99, 212, 0),
};

//category icons

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
