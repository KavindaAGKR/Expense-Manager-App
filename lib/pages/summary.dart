// import 'package:flutter/material.dart';
// import 'package:money_manager/components/widgets.dart';

// class Summary extends WidgetsWithTitle {

//   const Summary({super.key}) : super(title: "Summary");

//   @override
//   Widget build(BuildContext context) {
//     return const Text("Summary!");
//   }
// }

//import 'package:expense_tracker/components/expense_summary.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/server/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    Database db = Database();
    db.loadData();

    double totalExpense = db.expenseList.isNotEmpty
        ? db.expenseList
            .map((expense) => expense.amount)
            .reduce((a, b) => a + b)
        : 0.0;

    double totalIncome = db.incomeList.isNotEmpty
        ? db.incomeList.map((income) => income.amount).reduce((a, b) => a + b)
        : 0.0;

    Map<Category, double> categoryExpenses = {};
    db.expenseList.forEach((expense) {
      if (categoryExpenses.containsKey(expense.category)) {
        categoryExpenses[expense.category] =
            (categoryExpenses[expense.category] ?? 0) + expense.amount;
      } else {
        categoryExpenses[expense.category] = expense.amount;
      }
    });

    // Prepare data for the PieChart
    List<PieChartSectionData> pieChartSections = categoryExpenses.entries
        .map((entry) => PieChartSectionData(
              value: entry.value,
              color: CategoryColors[entry.key]!,
              title: entry.key.toString().split('.').last,
            ))
        .toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(31, 136, 6, 6),
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
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Container(
            height: 170,
            width: 380,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color.fromARGB(223, 241, 173, 13),
            ),
            //color: Colors.black87 ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total Income : Rs ' + totalIncome.toString(),
                    style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0))),
                Text('Total Expenses : Rs ' + totalExpense.toString(),
                    style: TextStyle(fontSize: 20, color: const Color.fromARGB(255, 0, 0, 0))),
                const SizedBox(
                  height: 20,
                ),
                _heading(totalIncome, totalExpense),
              ],
            ),
          ),

          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     //Text('asdsadaaaaaaaaaaaaaaaaaaaaaaaa'),

          //   ],),
          const SizedBox(
            height: 30,
          ),

          const Text('Summary of Expenses',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 30,
          ),

          _pieChart(totalExpense, pieChartSections),

          const SizedBox(
            height: 50,
          ),

          Container(
              height: 120,
              width: 400,
              //color: Colors.black,
              margin: const EdgeInsets.only(
                left: 20,
              ),
              //color: const Color.fromARGB(255, 0, 0, 0),
              child: _legends(pieChartSections)),
        ],
      ),
    );
  }

  Row _heading(double totalIncome, double totalExpense) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Balance : ",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          "Rs ${totalIncome - totalExpense}",
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Column _legends(List<PieChartSectionData> pieChartSections) {
    return Column(
      children: pieChartSections.map((section) {
        return Row(
          //mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 20,
              height: 20,
              color: section.color,
              //child: const SizedBox(height: 20,),
            ),
            const SizedBox(width: 5),
            Text(section.title),
          ],
        );
      }).toList(),
    );
  }

  Expanded _pieChart(
      double totalExpense, List<PieChartSectionData> pieChartSections) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
              swapAnimationDuration: const Duration(milliseconds: 750),
              swapAnimationCurve: Curves.easeInOut,
              PieChartData(
                sections: pieChartSections,
                sectionsSpace: 0,
                centerSpaceRadius: 80,
                centerSpaceColor: Color.fromARGB(255, 236, 193, 216),
              )),
          Text("Expenses \n Rs. ${totalExpense.toString()}"),
        ],
      ),
    );
  }
}
