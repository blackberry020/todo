import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo/logic/management/my_app_state.dart';
import 'package:todo/presentation/pages/home_page.dart';

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
