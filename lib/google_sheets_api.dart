import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

//create credentials
class GoogleSheetApi {
  static const _credentials = r''' 

        {
          "type": "service_account",
          "project_id": "shop-370018",
          "private_key_id": "240a1c8c5319c47537bdb82c71384b670f04e44c",
          "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCyDG3JRQVaHvRO\nC7HiOb9MqyTLKUuOlk2kPDo35+4fWtxWgTkVyT+opgwWLdMWnZro7RNoHKGgUcZe\n1Lb5oed5Ll5CO8A7g0AeFsHw9c9eMnIEPjLI6zgfOKla/el123Xen4GDW2fRi/eU\nQs8h+zpboIq1etnuID9VT0jskO4ASB8PZUJ3cM/XLVJUIiUkPOj+T5rxbmtwluhT\nnXoXiqHM0Fsiz8KWzbq3I4/NQ5vih7Qjjr7QeN3rcwGDhiOkN5V6tZL21CYXMezq\n8KATUSP9WH/9NgR3cKi074BYQQhSk2HPJzHvjmYwpgWXGLzQ+ltkBGfq3oEDqWW7\nh0PrrcRbAgMBAAECggEAKQ72rkhNYKfsvKazwbCBbeO1m2gNdXcxtmLxJf1FC1P/\npa8tA9oh5PlNpjuxBvEXTQmGxSZ9GyRgc3PoMg7k+yv3Lpzqyo6M1aN32+JDjLxj\nUJkrSuv7SC/f1gzhrn0KZGkyC6Gjgk4drMHvVC3EGmceNZV79g7XrAuZjHwrdkLI\n8p9OxkmKrpKiFtZib3QVl01TfC6Dp+6HA4rxyjX6b60kBJ9qjt/nK77Y77WcXy9R\nJC+RnfSFmX1XGejJub5L5l2Sm0X9Cn75fjlOjftq0T1MHQ6zdjbtpgITWXaATx1r\nBvsJaTdssgevELpNatTNpLPBWFib4RanqfYERS/LkQKBgQDZq2efwPMAjzTsLHUE\nM4hczVyqr3nRZ8yfCUSJuswh6o4OTVKgWlyCYoleGgc7rxvUB9Z728+XRFMDtXme\nL+bylO9JlFm5rvoPtzSKcKtTiaZNV1PT3DUDLjHZTRL0mYZYCztSTgKek0fGUvEw\nYyZLf9l2U/rVaHNfoNYvCnamiQKBgQDRZuZjc8wI5+dQMamMxuy71ZBsrvD/FdAu\nl+DRg3zZh/sgnC02UiZ78LIIZK4exMwzy7AIUhyWc9n4579Ruvv/dVM4WLpp9a0Q\ny4vC2WmDvaIVM679wbqXGGeLk4q80KbTUQF213uWZihHFck6usuz/QK2b75zj2Dm\nmqegKosawwKBgCrU768f6LFTfLZ8iQoqmcqpHnL31KDALCOfTz1K5KBH52wpCvlC\nzrFZcm5x8Lpt2qv+XtZAirjZWPyB2UynYGqbo/p2lrFTHSG6izwyr4PgsjjF1lj6\nG/RkQqrf37sB+s2YaDPp5doOYTFFYPCEkiSJI+GE5PbZdtp6a6sWBAMBAoGAaZ9u\nvGFvXFqlGZVDQYghZwltRPTlCLXXAXmIZAXf1tW5PRSp1YmQcdnR41vtXAXGPqYS\nT9AjLVyYaO10WmRnsc5bQMO4m7PZLOyOvaTujQ39EJa2QLcUSBx+NjAgvea9Dz//\n7hL4+r7iuCBsFRydnVcUpDMvLJj4trjxrl9nNQMCgYBOas3otVdfVzC5BWaKqUze\n0BBEccHNE3ssE7LV8jrbHLJqWlA/Gwvp5bzbwgz7p2DrTsCVKXvPE2YVbiWIOEZ1\ndIPL+1ycJh183/w7tX++M7HUmzqSTHF6LojwKWRYYTdpvB/cHXbzGmxh58Mac63J\nQCqGLSIkYpiUTKY08QuGRw==\n-----END PRIVATE KEY-----\n",
          "client_email": "flutter-shop-tracker-expensive@shop-370018.iam.gserviceaccount.com",
          "client_id": "111569452627370645842",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-shop-tracker-expensive%40shop-370018.iam.gserviceaccount.com"
        }
        

        ''';
  static const _spreadsheetId = "1QbS3P_6BZ6RgW7fv_K6kut5_89llMsxw68eodloPpq0";
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
