import 'package:expense_tracker/data/add_data.dart';
import 'package:expense_tracker/data/utity.dart';
import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/data/top.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List days = ["Day", "Week", "Month", "Year"];
  List day = ['Day', 'Week', 'Month', 'Year'];
  List f = [today(), week(), month(), year()];
  List<Add_date> a = [];
  int index_color = 0;
  ValueNotifier kj = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        color: Colors.black,
        child: Text("hello"),
      )),
    );
  }
}
