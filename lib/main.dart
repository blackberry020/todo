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
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Todo app',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: context.watch<MyAppState>().isDarkTheme ? ColorScheme.dark() : ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 18, 211, 44)),
            ),
            home: MyHomePage(),
            debugShowCheckedModeBanner: false,
          );
        }
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPageIndex = 0;
  Set<dynamic> todos = {};
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

class TodoPage extends StatelessWidget {
  @override 
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
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
          SizedBox(
            height: 300,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('You have '
                      '${appState.todos.length} TODOs:', textAlign: TextAlign.center,),
                ),
                if (appState.todos.isNotEmpty)
                  for (var cur in appState.todos)
                    ListTile(
                      leading: const Icon(Icons.today),
                      title: Text(cur),
                    ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: 
        SafeArea(
          child: Switch(
           value: appState.isDarkTheme,
           onChanged: (val) {
             appState.themeChanged(val);
           },
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

  final pages = [TodoPage(), const Placeholder(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(
            body: Row(
              children: [
                  NavigationRail(
                    extended: constraints.maxWidth >= 500,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.today), 
                        label: Text('TODO')
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.done), 
                        label: Text('Done')
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings), 
                        label: Text('Settings')
                      ),
                    ], 
                    selectedIndex: appState.selectedPageIndex,
                    onDestinationSelected: (int newIndex) {
                      setState(() {
                        appState.selectedPageIndex = newIndex;
                        if (newIndex >= pages.length) throw "there is no page for $newIndex";
                      });
                    },
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                Expanded(
                  child: Container(
                            child: pages[appState.selectedPageIndex],
                          )
              ),
              ],
            ),
          );
        }
      ),
    );
  }
}