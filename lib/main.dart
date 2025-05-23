import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'lib.dart';

void main() async {

  // WidgetsFlutterBinding.ensureInitialized();
  // final storage = LocalStorage();
  // await storage.addFakeDate("2024-05-24");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ExerciseRepository();
    final localStorage = LocalStorage();

    return MaterialApp(
      title: 'Exercise App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            ExerciseListBloc(repository, localStorage)..add(LoadExercises()),
        child: const HomeScreen(),
      ),
    );
  }
}
