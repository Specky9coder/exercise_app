import '../../../../lib.dart';

class ExerciseListInitial extends ExerciseListState {}

class ExerciseListError extends ExerciseListState {
  final String message;

  ExerciseListError(this.message);
}

abstract class ExerciseListState {}

class ExerciseListLoading extends ExerciseListState {}

class ExerciseListLoaded extends ExerciseListState {
  final List<Exercise> exercises;
  final int continuousDays;

  ExerciseListLoaded(this.exercises, this.continuousDays);
}
