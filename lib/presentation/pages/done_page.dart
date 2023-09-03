import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/logic/management/my_app_state.dart';

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
