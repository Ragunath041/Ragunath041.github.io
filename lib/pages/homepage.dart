import 'package:expense_tracker/components/my_list_tile.dart';
import 'package:expense_tracker/database/expense_databse.dart';
import 'package:expense_tracker/helper/helper_function.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ensure widgets are bound before accessing context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseDatabase>(context, listen: false).readExpenses();
    });
  }

  void openNewExpenseBox() {
    nameController.clear();
    amountController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "New Expense",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                hintText: "Amount",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        actions: [
          _minimalCancelButton(),
          _minimalCreateNewExpenseButton(),
        ],
      ),
    );
  }

  void openEditBox(Expense expense) {
    nameController.text = expense.name;
    amountController.text = expense.amount.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Edit Expense",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                hintText: "Amount",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        actions: [
          _minimalCancelButton(),
          _minimalEditExpenseButton(expense),
        ],
      ),
    );
  }

  void openDeleteBox(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Delete Expense?",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text("Are you sure you want to delete this expense?"),
        actionsPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        actions: [
          _minimalCancelButton(),
          _minimalDeleteButton(expense.id),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseDatabase>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Color.fromARGB(173, 45, 49, 50), // Powder white background
        // appBar: AppBar(
        //   title: const Text(
        //     'Expense Tracker',
        //     style: TextStyle(
        //       fontWeight: FontWeight.bold,
        //       fontSize: 22,
        //       color: Colors.white,
        //     ),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: Color.fromARGB(255, 140, 189, 246), // Consistent blue color
        //   elevation: 0, // No shadow for cleaner look
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: openNewExpenseBox,
          backgroundColor: Color.fromARGB(255, 4, 127, 249),
          elevation: 4,
          child: const Icon(Icons.add, size: 30),
        ),
        body: Column(
          children: [
            _buildTotalExpenseSection(
                value.getTotalExpense(value.allExpense)),
            Expanded(
              child: value.allExpense.isEmpty
                  ? const Center(
                      child: Text(
                        "No expenses added yet!",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: value.allExpense.length,
                      itemBuilder: (context, index) {
                        Expense individualExpense = value.allExpense[index];
                        return MyListTitle(
                          title: individualExpense.name,
                          trailing:
                              "\₹${individualExpense.amount.toStringAsFixed(2)}",
                          onEditPressed: (context) =>
                              openEditBox(individualExpense),
                          onDeletePressed: (context) =>
                              openDeleteBox(individualExpense),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Total Expense Section
  Widget _buildTotalExpenseSection(double total) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Color.fromARGB(255, 0, 6, 9),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Expenses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Minimal Cancel Button
  Widget _minimalCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
        nameController.clear();
        amountController.clear();
      },
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.grey, fontSize: 16),
      ),
    );
  }

  // Minimal Create New Expense Button
  Widget _minimalCreateNewExpenseButton() {
    return ElevatedButton(
      onPressed: () async {
        double? amount = convertStringtoDouble(amountController.text);
        if (nameController.text.isNotEmpty && amount != null) {
          Navigator.pop(context);
          Expense newExpense = Expense(
            name: nameController.text,
            amount: amount,
            date: DateTime.now(),
          );
          await context.read<ExpenseDatabase>().createNewExpense(newExpense);
          nameController.clear();
          amountController.clear();
        } else {
          // Optionally, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter valid name and amount'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF28A745), // Green color for save
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'Save',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Minimal Edit Expense Button
  Widget _minimalEditExpenseButton(Expense expense) {
    return ElevatedButton(
      onPressed: () async {
        double? amount = convertStringtoDouble(amountController.text);
        if (nameController.text.isNotEmpty || (amount != null)) {
          Navigator.pop(context);
          Expense updatedExpense = Expense(
            name: nameController.text.isNotEmpty
                ? nameController.text
                : expense.name,
            amount: amount != null ? amount : expense.amount,
            date: DateTime.now(),
          );

          int existingId = expense.id;
          await context
              .read<ExpenseDatabase>()
              .updateExpense(existingId, updatedExpense);
          nameController.clear();
          amountController.clear();
        } else {
          // Optionally, show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter a valid name or amount'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 38, 52, 255), // Orange color for edit
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'Edit',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  // Minimal Delete Button
  Widget _minimalDeleteButton(int id) {
    return ElevatedButton(
      onPressed: () async {
        Navigator.pop(context); // Close the dialog
        await context.read<ExpenseDatabase>().deleteExpense(id); // Delete the expense
        // Optionally, show a confirmation message or refresh the expense list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense deleted successfully'),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE53935), // Red color for delete action
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: const Text(
        'Delete',
        style: TextStyle(color: Color.fromARGB(255, 10, 0, 0), fontSize: 16),
      ),
    );
  }
}
