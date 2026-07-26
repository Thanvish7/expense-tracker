import 'dart:io';
import 'package:expense_tracker/model/expense.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Builds a CSV string from the expense list.
String buildCsv(List<Expense> expenses) {
  final buffer = StringBuffer();
  buffer.writeln('ID,Title,Amount,Date,Category');
  for (final e in expenses) {
    // Wrap title in quotes to handle commas inside titles
    final safeTitle = '"${e.title.replaceAll('"', '""')}"';
    buffer.writeln(
      '${e.id},$safeTitle,${e.amount.toStringAsFixed(2)},${e.formattedDate},${e.category.name}',
    );
  }
  return buffer.toString();
}

/// Writes CSV to a temp file and opens the system share sheet.
Future<void> exportToCsv(
  BuildContext context,
  List<Expense> expenses,
) async {
  if (expenses.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No expenses to export.')),
    );
    return;
  }

  try {
    final csv = buildCsv(expenses);
    final dir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File('${dir.path}/expenses_$timestamp.csv');
    await file.writeAsString(csv);

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'My Expenses',
    );
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }
}
