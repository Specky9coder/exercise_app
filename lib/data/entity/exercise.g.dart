// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      duration: (json['duration'] as num).toInt(),
      difficulty: json['difficulty'] as String,
      completed: json['completed'] as bool? ?? false,
      setsCompleted: (json['setsCompleted'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'duration': instance.duration,
      'difficulty': instance.difficulty,
      'completed': instance.completed,
      'setsCompleted': instance.setsCompleted,
    };
