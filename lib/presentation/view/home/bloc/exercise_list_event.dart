abstract class ExerciseListEvent {}

class LoadExercises extends ExerciseListEvent {}

class MarkExerciseCompleted extends ExerciseListEvent {
  final String exerciseId;
  MarkExerciseCompleted(this.exerciseId);
}

class TrackProgress extends ExerciseListEvent {}

