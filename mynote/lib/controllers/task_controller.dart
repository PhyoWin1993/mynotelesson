import 'package:get/get.dart';
import 'package:mynote/db/db_helper.dart';
import 'package:mynote/model/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTask() async {
    List<Map<String, dynamic>> items = await DBHelper.query();
    // debugPrint(items.toString());
    taskList.assignAll(items.map((e) => Task.fromMap(e)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
  }
}
