import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mynote/controllers/task_controller.dart';
import 'package:mynote/model/task.dart';

import 'package:mynote/ui/input_field.dart';
import 'package:mynote/util/button.dart';
import 'package:mynote/util/theme.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  //asigning value
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String endTime = "9:30 PM";
  String startTime = DateFormat("hh:mm a").format(DateTime.now());

  int _selectedRemind = 5;
  final List<int> _remindList = [5, 10, 15, 20];
  String _selectedRepeated = "None";
  final List<String> repeated = ["None", "Daily", "Weekly", "Monthly"];
  int _selectedColor = 0;

  //mothod
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              MyInputField(
                title: "Title",
                hint: "Enter your title",
                controller: _titleCtrl,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter your note",
                controller: _noteCtrl,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () async {
                    await _dateFromUser();
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                    title: "Start time",
                    hint: startTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: true);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: MyInputField(
                    title: "End time",
                    hint: endTime,
                    widget: IconButton(
                      onPressed: () {
                        _getTimeFromUser(isStartTime: false);
                      },
                      icon: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ))
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  items: _remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                        value: value.toString(),
                        child: Text(
                          value.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                ),
              ),

              // add secont selected Item
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeated,
                widget: DropdownButton(
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey,
                  ),
                  iconSize: 32,
                  elevation: 4,
                  style: subtitleStyle,
                  underline: Container(
                    height: 0,
                  ),
                  items: repeated.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.grey),
                        ));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedRepeated = value!;
                    });
                  },
                ),
              ), // end widget
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Create task",
                    onTap: () => _validateDate(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateDate() {
    if (_titleCtrl.text.isNotEmpty && _noteCtrl.text.isNotEmpty) {
      // add to DB
      _addTaskToDb();
      Navigator.pop(context);
    } else if (_titleCtrl.text.isEmpty || _noteCtrl.text.isEmpty) {
      debugPrint("GEt Snapbar Started");

      // Get.snackbar("Required", "All field are required!",
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.white,
      //     icon: const Icon(Icons.warning_amber_rounded),
      //     colorText: Colors.red);

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  var snackBar = SnackBar(
    content: SizedBox(
      height: 60,
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ),
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Required",
                style: TextStyle(color: Colors.red, fontSize: 20),
              ),
              Text(
                "All field are required!",
                style: TextStyle(color: Colors.red, fontSize: 16),
              )
            ],
          ))
        ],
      ),
    ),
    backgroundColor: Colors.black.withOpacity(0.9),
  );

  Column _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  _appBar(BuildContext context) {
    return AppBar(
      title: const Text("My Note App"),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios,
            size: 20, color: Get.isDarkMode ? Colors.white : Colors.black),
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

  _dateFromUser() async {
    DateTime? _datePicker = await showDatePicker(
        context: context,
        firstDate: DateTime(2021),
        initialDate: DateTime.now(),
        lastDate: DateTime(2029));
    if (_datePicker != null) {
      setState(() {
        _selectedDate = _datePicker;
      });
    } else {
      debugPrint("Some went wrong in date selecting.");
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);

    if (pickedTime == null) {
      debugPrint("Cancel");
    } else if (isStartTime == true) {
      setState(() {
        startTime = _formatedTime;
      });
    } else if (isStartTime == false) {
      setState(() {
        endTime = _formatedTime;
      });
    }
  }

  _showTimePicker() async {
    return await showTimePicker(
        initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
            hour: int.parse(startTime.split(":")[0]),
            minute: int.parse(startTime.split(":")[1].split(" ")[0])));
  }

  void _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: Task(
            note: _noteCtrl.text,
            title: _titleCtrl.text,
            date: DateFormat.yMd().format(_selectedDate),
            startTime: startTime,
            endTime: endTime,
            remind: _selectedRemind,
            repeat: _selectedRepeated,
            color: _selectedColor,
            isCompleted: 0));
    debugPrint(" Id is ==> $value");
    _taskController.getTask();
  }
}
