import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

//create credentials
class GoogleSheetApi {
  static const _credentials = r''' 


        ''';
  static const _spreadsheetId = "";
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    var now = new DateTime.now();
    var formatter = "${now.year}/${now.month}/${now.day}";
    print("formatter : ${formatter} ");

    _worksheet = ss.worksheetByTitle(formatter);
    _worksheet ??= await ss.addWorksheet(formatter);

    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 3, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionNote =
          await _worksheet!.values.value(column: 4, row: i + 1);
      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionType,
          transactionName,
          transactionAmount,
          transactionNote
        ]);
      }
    }
    // this will stop the circular loading indicator
    loading = false;
    print(currentTransactions);
  }

  static Future insert(
      String payment_type, String name, String amount, String note) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([payment_type, name, amount, note]);
    await _worksheet!.values.appendRow([payment_type, name, amount, note]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      print(currentTransactions[i][1]);
      if (currentTransactions[i][0] == 'income') {
        //("Moman Help :");

        totalIncome += double.parse(currentTransactions[i][2]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][0] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][2]);
      }
    }
    return totalExpense;
  }

  static Future deleteUser(history) async {
    final lista = await _worksheet!.values.allRows();
    for (var i = 0; i < lista.length; i++) {
      var riga = lista[i];
      if (riga[0] == history[0] &&
          riga[1] == history[1] &&
          riga[2] == history[2] &&
          riga[3] == history[3]) {
        //dati[0] contain the key
        _worksheet!.deleteRow(i + 1);
        break;
      }
    }
  }
}
