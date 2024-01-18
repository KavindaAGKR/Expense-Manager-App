
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/income.dart';
import 'package:expense_tracker/pages/welcome.dart';
import 'package:expense_tracker/server/categories_adapter.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(IncomeAdapter());

  await Hive.openBox("expenseDatabase");


  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(),
    );
  }
}
