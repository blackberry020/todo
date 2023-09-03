import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/logic/management/my_app_state.dart';

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
