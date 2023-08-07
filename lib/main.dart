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
      child: MaterialApp(
        title: 'Todo app',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var selectedPageIndex = 0;
  var todos = [];
  TextEditingController newTodoController = TextEditingController();

  void addNewTodo() {
    todos.add(newTodoController.text);
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
            child: ListView( // after adding this widget bug occured
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

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    late Widget page;

    switch (appState.selectedPageIndex) {
      case 0:
        page = TodoPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw ("there is no such page for $appState.selectedPageIndex");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 500,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.today), 
                      label: Text('TODO')
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.done), 
                      label: Text('done')
                    ),
                  ], 
                  selectedIndex: appState.selectedPageIndex,
                  onDestinationSelected: (int newIndex) {
                    setState(() {
                      appState.selectedPageIndex = newIndex;
                    });
                  },
                  backgroundColor: const Color.fromARGB(255, 116, 237, 108),
                )
              ),
              Expanded(
                child: Container(
                            child: page,
                          )
              ),
            ],
          ),
        );
      }
    );
  }
}