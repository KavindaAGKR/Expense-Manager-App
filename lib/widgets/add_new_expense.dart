import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddNewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  const AddNewExpense({Key? key, required this.onAddExpense});

  @override
  State<AddNewExpense> createState() => _AddNewExpenseState();
}

class _AddNewExpenseState extends State<AddNewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  DateTime _selectedDate = DateTime.now();

  Category _selectedCategory = Category.work;

  Future<void> _openDateModal() async {
    try {
      final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    } catch (err) {
      print(err.toString());
    }
  }

  void _handleFormSubmit() {
    final userAmount = double.parse(_amountController.text.trim());
    if (_titleController.text.isEmpty || userAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter valid data"),
            content: const Text("Enter valid data"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      Expense newExpense = Expense(
        amount: userAmount,
        dateTime: _selectedDate,
        name: _titleController.text.trim(),
        category: _selectedCategory,
        description: _descriptionController.text,
      );
      widget.onAddExpense(newExpense);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 241, 222, 152),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Close the model button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Padding(
                  padding: EdgeInsets.all(5.5),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 30.0,
                  ),
                ),
              ),
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expense",
              labelText: "Title",
            ),
            keyboardType: TextInputType.text,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Enter description here",
              labelText: "Description",
            ),
            keyboardType: TextInputType.text,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              // Datepicker
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formattedDate.format(_selectedDate)),
                  IconButton(
                    onPressed: _openDateModal,
                    icon: const Icon(Icons.date_range_outlined),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    // Save and close button
                  ],
                ),
              ),
            ],
          ),
          ElevatedButton(
                      onPressed: _handleFormSubmit,
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 157, 104, 243)),
                      ),
                      child: const Text("Save"),
                    ),
        ],
      ),
    );
  }
}
