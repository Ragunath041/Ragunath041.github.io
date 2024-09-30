import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/database/expense_databse.dart';
import 'pages/homepage.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await ExpenseDatabase.initialize();
  runApp(
    ChangeNotifierProvider(
      create : (context) => ExpenseDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  MyHomePage(),
    );
  }
}

