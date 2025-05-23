import 'dart:convert';

import '../../lib.dart';

import 'package:http/http.dart' as http;

class ExerciseRepository {
  final String _baseUrl =
      'https://68252ec20f0188d7e72c394f.mockapi.io/dev/workouts';

  Future<List<Exercise>> fetchExercises() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Exercise.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }
}
