import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Todo app',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: context.watch<MyAppState>().isDarkTheme
                  ? const ColorScheme.dark()
                  : ColorScheme.fromSeed(
                      seedColor: const Color.fromARGB(255, 18, 211, 44))),
          home: MyHomePage(),
          debugShowCheckedModeBanner: false,
        );
      }),
    );
  }
}

class TodoInfo {
  String title;
  String description;

  TodoInfo({required this.title, required this.description});
}

class EnterTodoCard extends StatelessWidget {
  const EnterTodoCard({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Container(
      width: 320,
      height: 130,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 0, 26, 255),
          width: 2,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.today),
                color: Colors.indigo,
                onPressed: () {},
                padding: const EdgeInsets.only(right: 10, top: 15),
                iconSize: 35,
              ),
              SizedBox(
                  width: 180,
                  height: 45,
                  child: TextFormField(
                      focusNode: appState.titleFieldFocus,
                      controller: appState.newTodoTitleController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: 'Write your new TODO',
                      ),
                      onFieldSubmitted: (String? todoToAdd) {
                        if (appState.newTodoTitleController.text.trim() != "") {
                          appState.descriptionFieldFocus.requestFocus();
                        } else {
                          appState.titleFieldFocus.requestFocus();
                        }
                      }))
            ],
          ),
          Expanded(
              child: TextFormField(
            controller: appState.newTodoDescriptionController,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              hintText: 'Describe what do you want to do',
            ),
            onFieldSubmitted: (String? todoToAdd) {
              appState.addNewTodo();
            },
            focusNode: appState.descriptionFieldFocus,
          ))
        ],
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  TextEditingController newTodoTitleController = TextEditingController();
  TextEditingController newTodoDescriptionController = TextEditingController();

  FocusNode descriptionFieldFocus = FocusNode();
  FocusNode titleFieldFocus = FocusNode();

  Set<TodoInfo> todos = {};
  Set<TodoInfo> done = {};
  Set<int> todosToDeleteIndexes = {};

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

  void themeChanged(bool theme) {
    isDarkTheme = theme;
    theme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}

class Todo extends StatefulWidget {
  final TodoInfo todo;

  const Todo(
      {required this.todo,
      required this.deleteTodo,
      required this.moveToDone,
      required this.selectionChanged});

  final void Function() moveToDone;

  final void Function() deleteTodo;

  final void Function() selectionChanged;

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<Widget> buttons = [];

    if (appState.isEditMode) {
      buttons = [
        Checkbox(
          value: isSelected,
          onChanged: (bool? value) {
            setState(() {
              isSelected = value!;
            });
          },
        )
      ];
    } else {
      buttons = [
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
      ];
    }

    return ListTile(
        leading:
            const Icon(Icons.today, color: Color.fromARGB(255, 0, 94, 255)),
        title: Text(widget.todo.title),
        subtitle: Text(widget.todo.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: buttons,
        ));
  }
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Widget getEditModeButtons(MyAppState appState) {
    return Row(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.done),
          color: Colors.green,
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.delete),
          color: Colors.red,
          iconSize: 30,
        ),
        IconButton(
          onPressed: () {
            setState(() {
              appState.isEditMode = !appState.isEditMode;
            });
          },
          icon: const Icon(Icons.cancel),
          color: Colors.red,
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
            const EnterTodoCard(),
            const SizedBox(
              width: 10,
            ),
            ElevatedButton(
              onPressed: appState.addNewTodo,
              child: const Text('Add'),
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
              selectionChanged: () {},
            ),
          ),
        )
      ]),
    );
  }
}

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        Text('You have done ${appState.done.length} TODOs!',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        Expanded(
          child: ListView.builder(
              itemCount: appState.done.length,
              itemBuilder: (context, index) => ListTile(
                    leading: Icon(
                      Icons.done,
                      color:
                          appState.isDarkTheme ? Colors.purple : Colors.green,
                    ),
                    title: Text(appState.done.elementAt(index).title),
                    subtitle: Text(appState.done.elementAt(index).description),
                  )),
        )
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Dark theme',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 10),
              Switch(
                value: appState.isDarkTheme,
                onChanged: (val) {
                  appState.themeChanged(val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final pages = [TodoPage(), const DonePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              NavigationRail(
                extended: constraints.maxWidth >= 500,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.today), label: Text('TODO')),
                  NavigationRailDestination(
                      icon: Icon(Icons.done), label: Text('Done')),
                  NavigationRailDestination(
                      icon: Icon(Icons.settings), label: Text('Settings')),
                ],
                selectedIndex: appState.selectedPageIndex,
                onDestinationSelected: (int newIndex) {
                  setState(() {
                    appState.selectedPageIndex = newIndex;
                    if (newIndex >= pages.length) {
                      throw "there is no page for $newIndex";
                    }
                  });
                },
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
              Expanded(
                  child: Container(
                child: pages[appState.selectedPageIndex],
              )),
            ],
          ),
        );
      }),
    );
  }
}
