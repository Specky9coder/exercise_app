import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  final String id;
  final String name;
  final String description;
  final int duration;
  final String difficulty;

  @JsonKey(defaultValue: false)
  bool completed;

  @JsonKey(defaultValue: 0)
  int setsCompleted;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    this.completed = false,
    this.setsCompleted = 0,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  Exercise copyWith({
    bool? completed,
    int? setsCompleted,
  }) {
    return Exercise(
      id: id,
      name: name,
      description: description,
      duration: duration,
      difficulty: difficulty,
      completed: completed ?? this.completed,
      setsCompleted: setsCompleted ?? this.setsCompleted,
    );
  }
}
