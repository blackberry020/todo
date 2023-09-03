import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/logic/management/my_app_state.dart';

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
              appState.titleFieldFocus.requestFocus();
            },
            focusNode: appState.descriptionFieldFocus,
          ))
        ],
      ),
    );
  }
}
