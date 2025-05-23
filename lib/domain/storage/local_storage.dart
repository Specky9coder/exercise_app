import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _completedKey = 'completed_exercises';
  static const _datesKey = 'exercise_dates';
  static const _setsDataKey = 'sets_data';

  Future<Set<String>> getCompletedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_completedKey)?.toSet() ?? <String>{};
  }

  Future<void> saveCompletedExercises(Set<String> completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_completedKey, completed.toList());
  }

  Future<List<String>> getCompletedDates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_datesKey) ?? [];
  }

  Future<void> saveCompletedDates(List<String> dates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_datesKey, dates);
  }

  Future<Map<String, Map<String, int>>> getSetsData() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_setsDataKey);
    if (rawJson == null) return {};

    try {
      final Map<String, dynamic> parsed = json.decode(rawJson);
      return parsed.map((date, setsMap) {
        if (setsMap is Map) {
          return MapEntry(
            date,
            setsMap.map((exerciseId, setsCount) => MapEntry(
                exerciseId.toString(),
                int.tryParse(setsCount.toString()) ?? 0)),
          );
        } else {
          return MapEntry(date, {});
        }
      });
    } catch (e) {
      await prefs.remove(_setsDataKey);
      return {};
    }
  }

  Future<void> saveSetsData(Map<String, Map<String, int>> setsData) async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = json.encode(setsData);
    await prefs.setString(_setsDataKey, rawJson);
  }
}
