import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyListTitle extends StatelessWidget {
  final String title;
  final String trailing;
  final Function(BuildContext) onEditPressed;
  final Function(BuildContext) onDeletePressed;

  const MyListTitle({
    Key? key,
    required this.title,
    required this.trailing,
    required this.onEditPressed,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        color: Color.fromARGB(255, 231, 234, 235), // Pure white for expense cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 3,
        shadowColor: Color.fromARGB(255, 5, 0, 0).withOpacity(0.1),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            formatDate(DateTime.now()), // Update with actual date if available
            style: const TextStyle(color: Color.fromARGB(255, 45, 44, 44)),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                trailing,
                style: const TextStyle(
                  color: Color.fromARGB(255, 69, 194, 94),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: const Color.fromARGB(255, 249, 144, 137),
                onPressed: () => onDeletePressed(context),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                color: Color.fromARGB(255, 180, 195, 255),
                onPressed: () => onEditPressed(context),
              ),
            ],
          ),
          onTap: () => onEditPressed(context),
          onLongPress: () => onDeletePressed(context),
        ),
      ),
    );
  }
}

// Ensure you have this utility function in your helper file
String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date); // Example: "Sep 29, 2024"
}
