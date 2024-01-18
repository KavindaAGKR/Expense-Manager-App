import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'income.g.dart';


class IncomeModel extends ChangeNotifier {
  final List<Income> _incomes = [];

  List<Income> get incomes => _incomes;

  void addIncome(Income income) {
    _incomes.add(income);
    notifyListeners();
  }
}

@HiveType(typeId: 3)
class Income {

  @HiveField(0)
  final String name;

  @HiveField(1)
  final double amount;
  
  Income({
    required this.name,
    required this.amount,
  });

}
