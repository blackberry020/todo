import 'package:flutter/material.dart';
import 'package:todo/logic/data/todo_info.dart';

class MyAppState extends ChangeNotifier {
  TextEditingController newTodoTitleController = TextEditingController();
  TextEditingController newTodoDescriptionController = TextEditingController();

  FocusNode descriptionFieldFocus = FocusNode();
  FocusNode titleFieldFocus = FocusNode();

  Set<TodoInfo> todos = {};
  Set<TodoInfo> done = {};
  Set<TodoInfo> selectedTodos = {};

  bool isDarkTheme = false;
  bool isEditMode = false;

  var selectedPageIndex = 0;

  void addNewTodo() {
    var todoTitle = newTodoTitleController.text.trim();
    var todoDescription = newTodoDescriptionController.text.trim();

    var todoToAdd = TodoInfo(title: todoTitle, description: todoDescription);

    if (todoToAdd.title != "") {
      todos.add(todoToAdd);
    }

    newTodoTitleController.clear();
    newTodoDescriptionController.clear();
    notifyListeners();
  }

  void moveSelectedToDone() {
    done.addAll(selectedTodos);
    todos.removeAll(selectedTodos);
    selectedTodos.clear();

    notifyListeners();
  }

  void deleteSelected() {
    todos.removeAll(selectedTodos);
    selectedTodos.clear();

    notifyListeners();
  }

  void themeChanged(bool theme) {
    isDarkTheme = theme;
    theme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}
