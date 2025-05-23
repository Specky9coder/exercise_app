import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

// class LocalStorage {
//   static const _completedKey = 'completed_exercises';
//   static const _datesKey = 'exercise_dates';
//   static const _setsDataKey = 'sets_data';
//
//   Future<Set<String>> getCompletedExercises() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_completedKey)?.toSet() ?? <String>{};
//   }
//
//   Future<void> saveCompletedExercises(Set<String> completed) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(_completedKey, completed.toList());
//   }
//
//   Future<List<String>> getCompletedDates() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getStringList(_datesKey) ?? [];
//   }
//
//   Future<void> saveCompletedDates(List<String> dates) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setStringList(_datesKey, dates);
//   }
//
//   Future<Map<String, int>> getSetsData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString(_setsDataKey);
//     if (jsonString != null) {
//       final Map<String, dynamic> decoded = json.decode(jsonString);
//
//       return decoded.map((key, value) => MapEntry(key, value as int));
//     }
//     return {};
//   }
//
//   Future<void> saveSetsData(String exerciseId, int setsCompleted) async {
//     final prefs = await SharedPreferences.getInstance();
//     final currentData = await getSetsData();
//     currentData[exerciseId] = setsCompleted;
//     final jsonString = json.encode(currentData);
//     await prefs.setString(_setsDataKey, jsonString);
//   }
//   Future<void> addFakeDate(String dateStr) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> dates = prefs.getStringList(_datesKey) ?? [];
//     if (!dates.contains(dateStr)) {
//       dates.add(dateStr);
//       await prefs.setStringList(_datesKey, dates);
//     }
//   }
// }


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

  // Future<Map<String, Map<String, int>>> getSetsData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final rawJson = prefs.getString(_setsDataKey);
  //   if (rawJson == null) return {};
  //
  //   final Map<String, dynamic> parsed = json.decode(rawJson);
  //   return parsed.map((date, setsMap) =>
  //       MapEntry(date, Map<String, int>.from((setsMap as Map).map((k, v) => MapEntry(k.toString(), v as int)))));
  // }

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
            setsMap.map((exerciseId, setsCount) =>
                MapEntry(exerciseId.toString(), int.tryParse(setsCount.toString()) ?? 0)),
          );
        } else {
          // If somehow a non-map (like int) got saved, skip it
          return MapEntry(date, {});
        }
      });
    } catch (e) {
      // If decoding or casting fails, reset to avoid crash
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
