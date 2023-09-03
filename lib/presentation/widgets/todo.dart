import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/logic/data/todo_info.dart';
import 'package:todo/logic/management/my_app_state.dart';

class Todo extends StatefulWidget {
  final TodoInfo todo;
  final MyAppState appState;

  Todo(
      {required this.todo,
      required this.deleteTodo,
      required this.moveToDone,
      required this.selectionChanged,
      required this.appState});

  final void Function() moveToDone;

  final void Function() deleteTodo;

  final void Function(bool) selectionChanged;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool isHover = false;

  Widget getTodoEditButtons() {
    return Checkbox(
      value: widget.appState.selectedTodos.contains(widget.todo),
      onChanged: (bool? value) {
        setState(() {
          widget.selectionChanged(value!);
        });
      },
    );
  }

  Widget getTodoMainButtons() {
    return Row(
      children: [
        IconButton(
          onPressed: widget.moveToDone,
          icon: const Icon(
            Icons.done,
            color: Colors.green,
          ),
        ),
        IconButton(
          onPressed: widget.deleteTodo,
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return InkWell(
      onHover: (bool val) {
        setState(() {
          isHover = val;
        });
      },
      onTap: () {},
      child: ListTile(
          leading:
              const Icon(Icons.today, color: Color.fromARGB(255, 0, 94, 255)),
          title: Text(widget.todo.title),
          subtitle: Text(widget.todo.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              appState.isEditMode
                  ? getTodoEditButtons()
                  : (isHover ? getTodoMainButtons() : const SizedBox())
            ],
          )),
    );
  }
}
