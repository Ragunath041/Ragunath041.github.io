
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
class ExpenseDatabase extends ChangeNotifier
{
  static late Isar isar;
  final List <Expense> _allExpenses = [];
  static Future <void> initialize() async
  {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ExpenseSchema] , directory: dir.path);
  }
  List <Expense> get allExpense => _allExpenses;
  //create
  Future <void> createNewExpense(Expense newExpense) async
  {
    await isar.writeTxn(() => isar.expenses.put(newExpense));
    await readExpenses();
  }
  Future <void> readExpenses() async
  {
    List <Expense> fetchedExpenses = await isar.expenses.where().findAll();
    _allExpenses.clear();
    _allExpenses.addAll(fetchedExpenses);
    notifyListeners();
  } 

  Future <void> updateExpense(int id , Expense updateExpense) async
  {
    updateExpense.id = id;
    await isar.writeTxn(() => isar.expenses.put(updateExpense));
    await readExpenses();
  }
  Future <void> deleteExpense(int id) async
  {
    await isar.writeTxn(() => isar.expenses.delete(id));
    await readExpenses();
  }

  double getTotalExpense(List<Expense> allExpenses) {
  double total = 0.0;
  for (Expense expense in allExpenses) {
    total += expense.amount;
  }
  return total;
}

}