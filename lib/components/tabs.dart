import 'package:expense_tracker/pages/expenses.dart';
import 'package:expense_tracker/pages/incomes.dart';
import 'package:expense_tracker/pages/summary.dart';
import 'package:flutter/material.dart';

class TabsController extends StatefulWidget {
  const TabsController({super.key});

  @override
  State<TabsController> createState() => _TabsControllerState();
}

class _TabsControllerState extends State<TabsController> {
  var _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _pages = [
    Expenses(),
    Summary(),
    Incomes(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.paid),
              label: 'Expenses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Summary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet),
              label: 'Incomes',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: Color.fromARGB(255, 107, 0, 102),
          unselectedItemColor: Color.fromARGB(255, 192, 191, 191),
          //backgroundColor: Color.fromARGB(255, 0, 0, 0),
          //fixedColor: Color.fromARGB(255, 53, 192, 69),
        ),
      ),
    );
  }
}
