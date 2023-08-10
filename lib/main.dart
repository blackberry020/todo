import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
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

class MyAppState extends ChangeNotifier {
  var selectedPageIndex = 0;
  Set<dynamic> todos = {};
  Set<dynamic> done = {};
  TextEditingController newTodoController = TextEditingController();
  bool isDarkTheme = false;

  void addNewTodo() {
    var todoToAdd = newTodoController.text.trim();

    if (todoToAdd != "") {
      todos.add(todoToAdd);
    }

    newTodoController.clear();
    notifyListeners();
  }

  void themeChanged(bool theme) {
    isDarkTheme = theme;
    theme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}

class Todo extends StatelessWidget {
  final String todo;

  Todo(
      {required this.todo, required this.deleteTodo, required this.moveToDone});

  final void Function() moveToDone;

  final void Function() deleteTodo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:
            const Icon(Icons.today, color: Color.fromARGB(255, 0, 94, 255)),
        title: Text(todo),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: moveToDone,
              icon: const Icon(
                Icons.done,
                color: Colors.green,
              ),
            ),
            IconButton(
              onPressed: deleteTodo,
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ));
  }
}

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: appState.newTodoController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your new TODO',
                  ),
                  onFieldSubmitted: (String? todoToAdd) {
                    appState.addNewTodo();
                  },
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: appState.addNewTodo,
                child: const Text('Add'),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have '
            '${appState.todos.length} TODOs:',
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
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        Expanded(
          child: ListView.builder(
              itemCount: appState.done.length,
              itemBuilder: (context, index) => ListTile(
                    leading: Icon(
                      Icons.done,
                      color:
                          appState.isDarkTheme ? Colors.purple : Colors.green,
                    ),
                    title: Text(appState.done.elementAt(index)),
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
  final pages = [TodoPage(), DonePage(), SettingsPage()];

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
