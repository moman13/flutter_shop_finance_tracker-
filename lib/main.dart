import 'package:expense_tracker/data/add_data.dart';
import 'package:expense_tracker/google_sheets_api.dart';
import 'package:flutter/material.dart';
import "package:expense_tracker/home.dart";
import "package:expense_tracker/statistics.dart";
import "package:expense_tracker/widgets/bottomnavigation.dart";
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  GoogleSheetApi().init();
  Hive.registerAdapter(AdddateAdapter());
  await Hive.openBox<Add_date>('data');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Avenir',
      ),
      home: Directionality(textDirection: TextDirection.rtl, child: Bottom()),
    );
  }
}
