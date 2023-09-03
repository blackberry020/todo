import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/logic/management/my_app_state.dart';

import 'package:todo/presentation/pages/todo_page.dart';
import 'package:todo/presentation/pages/done_page.dart';
import 'package:todo/presentation/pages/settings_page.dart';

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
