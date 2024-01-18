import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class AddNewExpense extends StatefulWidget {
  final void Function(Expense expense) onAddExpense;
  const AddNewExpense({
    super.key,
    required this.onAddExpense
  });

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
          context: context, firstDate: firstDate, lastDate: lastDate);

      setState(() {
        _selectedDate = pickedDate!;
      });
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
            return (AlertDialog(
              title: const Text("Enter valid data"),
              content: const Text(
                  "Enter valid data.Enter valid data.Enter valid data.Enter valid data.Enter valid data.Enter valid data"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Close"),
                )
              ],
            ));
          });
    } else {
      Expense newExpense = Expense(
          amount: userAmount,
          dateTime: _selectedDate,
          name: _titleController.text.trim(),
          category: _selectedCategory,
          description: _descriptionController.text);
      widget.onAddExpense(newExpense);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Close the model button
              GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                  )),
            ],
          ),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expense",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: "Enter description here",
              label: Text("Description"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
              // TextField(
              //   controller: _descriptionController,
              //     decoration: const InputDecoration(
              //       helperText: "Enter description here",
              //       label: Text('Description'),

              // )),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    label: Text('Amount'),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              //datepicker
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(formattedDate.format(_selectedDate)),
                  IconButton(
                      onPressed: _openDateModal,
                      icon: const Icon(Icons.date_range_outlined))
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
                  }),
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
                    //Save and close button
                    ElevatedButton(
                        onPressed: _handleFormSubmit,
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green)),
                        child: const Text("Save")),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
