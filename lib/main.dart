import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:people_account/pages/listpg.dart';
import 'package:people_account/services/notes_services.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DemoApiApp',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: CreateList(),
    );
  }
}
