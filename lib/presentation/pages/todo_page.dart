import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/presentation/widgets/enter_todo_card.dart';
import 'package:todo/logic/management/my_app_state.dart';
import 'package:todo/presentation/widgets/todo.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Widget getEditModeButtons(MyAppState appState) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              appState.deleteSelected();
              appState.isEditMode = false;
            });
          },
          icon: const Icon(Icons.delete),
          color: Colors.red,
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              appState.selectedTodos.clear();
              appState.isEditMode = false;
            });
          },
          icon: const Icon(Icons.cancel),
          color: Colors.red,
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              appState.moveSelectedToDone();
              appState.isEditMode = false;
            });
          },
          icon: const Icon(Icons.done),
          color: Colors.green,
          iconSize: 30,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const EnterTodoCard(),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: appState.addNewTodo,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
            appState.isEditMode
                ? getEditModeButtons(appState)
                : IconButton(
                    onPressed: () {
                      setState(() {
                        appState.isEditMode = !appState.isEditMode;
                      });
                    },
                    icon: const Icon(Icons.edit),
                    color: Colors.indigo,
                    iconSize: 30,
                  )
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            appState.todos.length == 1
                ? 'You have 1 TODO:'
                : 'You have ${appState.todos.length} TODOs:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: appState.todos.length,
            itemBuilder: (context, index) => Todo(
              appState: appState,
              todo: appState.todos.elementAt(index),
              deleteTodo: () {
                setState(() {
                  appState.todos.remove(appState.todos.elementAt(index));
                });
              },
              moveToDone: () {
                setState(() {
                  appState.done.add(appState.todos.elementAt(index));
                  appState.todos.remove(appState.todos.elementAt(index));
                });
              },
              selectionChanged: (bool isSelected) {
                if (isSelected) {
                  appState.selectedTodos.add(appState.todos.elementAt(index));
                } else {
                  appState.selectedTodos
                      .remove(appState.todos.elementAt(index));
                }
              },
            ),
          ),
        )
      ]),
    );
  }
}
