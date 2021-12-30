import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mynote/ui/add_task_page.dart';

import 'package:mynote/util/theme.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import '../util/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [_addTaskBar(), _addDateBar()],
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          //
          selectedDate = date;
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  "Today",
                  style: headingStyle,
                )
              ],
            ),
          ),

          //button
          MyButton(
            label: "+ add",
            onTap: () {
              // Get.to(const AddTaskPage());

              // Get.to(const AddTaskPage());
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const AddTaskPage();
              }));
              //   //end
            },
          )
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      title: const Text("My Note App"),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {},
        child: Icon(Get.isDarkMode
            ? Icons.wb_sunny_outlined
            : Icons.nightlife_outlined),
      ),
      actions: [
        CircleAvatar(
          child: CircleAvatar(
            child: Icon(
              Icons.ac_unit,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        )
      ],
    );
  }
}
