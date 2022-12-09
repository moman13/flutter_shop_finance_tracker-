import 'dart:async';
import 'dart:developer';

import 'package:expense_tracker/data/add_data.dart';
import 'package:expense_tracker/google_sheets_api.dart';
import 'package:expense_tracker/loading_circle.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/data/listdata.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/data/utity.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var history;
  final box = Hive.box<Add_date>('data');

  final List<String> day = [
    'Monday',
    "Tuesday",
    "Wednesday",
    "Thursday",
    'friday',
    'saturday',
    'sunday'
  ];
  // This widget is the root of your application.
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GoogleSheetApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
        body: SafeArea(
            child: GoogleSheetApi.loading == true
                ? LoadingCircle()
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 340,
                          child: _head(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("السجل اليومي",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'bahij',
                                      fontSize: 19,
                                      color: Colors.black)),
                              Text("عرض الكل",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      fontFamily: 'bahij',
                                      color: Colors.grey))
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                          delegate:
                              SliverChildBuilderDelegate((context, index) {
                        //  history = box.values.toList()[index];
                        history = GoogleSheetApi.currentTransactions[index];

                        return getList(history, index);
                      }, childCount: GoogleSheetApi.currentTransactions.length))
                    ],
                  )));
  }

  Widget getList(history, int index) {
    return Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) {
          GoogleSheetApi.deleteUser(history);
          // GoogleSheetApi.countRows();
          setState(() {});
        },
        child: get(index, history));
  }

  ListTile get(int index, history) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          "images/food.png",
          height: 40,
        ),
      ),
      title: Text(history[1],
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
      subtitle: Text(
        history[3],
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Text(
        '\₪ ${history[2]}',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: history[0] == 'income' ? Colors.green : Colors.red),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                  color: Color(0xff368983),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Stack(
                children: [
                  Positioned(
                      top: 35,
                      right: 320,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Color.fromRGBO(250, 250, 250, 0.1),
                          child: Icon(Icons.notification_add_outlined,
                              size: 30, color: Colors.white),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "أهلا وسهلا",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              fontFamily: "Avenir",
                              color: Colors.white),
                        ),
                        Text(
                          "البلبيسي للادوات الزراعية",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: "Avenir",
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 140,
          left: 37,
          child: Container(
            width: 320,
            height: 170,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(47, 125, 121, 0.3),
                    offset: Offset(0, 6),
                    blurRadius: 12,
                    spreadRadius: 6,
                  )
                ],
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 47, 125, 121)),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "المجموع اليومي",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                      Icon(Icons.more_horiz, color: Colors.white)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15, top: 5),
                  child: Row(
                    children: [
                      Text(
                        '\₪ ${total()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(Icons.arrow_downward,
                                color: Colors.white, size: 19),
                          ),
                          SizedBox(width: 7),
                          Text(
                            "المبيعات",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13,
                            backgroundColor: Color.fromARGB(255, 85, 145, 141),
                            child: Icon(Icons.arrow_upward,
                                color: Colors.white, size: 19),
                          ),
                          SizedBox(width: 7),
                          Text(
                            "المصاريف",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\₪ ${income()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      Text(
                        '\₪ ${expenses()}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
