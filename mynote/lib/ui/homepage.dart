import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mynote/controllers/task_controller.dart';
import 'package:mynote/model/task.dart';
import 'package:mynote/ui/add_task_page.dart';
import 'package:mynote/ui/task_tile.dart';
import 'package:mynote/util/button.dart';
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
  final _taskController = Get.put(TaskController());
  @override
  void initState() {
    super.initState();
    _taskController.getTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [_addTaskBar(), _addDateBar(), _showTasks()],
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
            onTap: () async {
              // Get.to(const AddTaskPage());
              // await Get.to(const AddTaskPage());

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

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showBottonSheet(
                                context, _taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        )
                      ],
                    ),
                  ),
                ));
          });
    }));
  }

  _bottonSheetButton(
      {required String label,
      required Function()? ontap,
      required Color clr,
      bool isClose = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: isClose == true ? Colors.red : clr,
            border:
                Border.all(width: 2, color: isClose == true ? Colors.red : clr),
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void showBottonSheet(BuildContext context, Task task) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(top: 4),
            height: task.isCompleted == 1
                ? MediaQuery.of(context).size.height * 0.24
                : MediaQuery.of(context).size.height * 0.32,
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            child: Column(
              children: [
                Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
                ),
                const SizedBox(
                  height: 20,
                ),

                // add first btn
                task.isCompleted == 1
                    ? Container()
                    : _bottonSheetButton(
                        label: "Task Completed",
                        ontap: () {
                          Navigator.of(context).pop();
                        },
                        clr: primaryClr,
                        context: context),
                // add sec btn

                _bottonSheetButton(
                    label: "Delete Task",
                    ontap: () {
                      Navigator.of(context).pop();
                    },
                    clr: Colors.red[300]!,
                    context: context),
                // add third btn
                const SizedBox(
                  height: 20,
                ),

                _bottonSheetButton(
                    label: "Close",
                    ontap: () {
                      Navigator.of(context).pop();
                    },
                    clr: Colors.red[300]!,
                    context: context,
                    isClose: true),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
