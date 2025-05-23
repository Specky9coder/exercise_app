abstract class ExerciseDetailState {}

class ExerciseDetailInitial extends ExerciseDetailState {}

class ExerciseInProgress extends ExerciseDetailState {
  final int elapsedSeconds;
  final int totalSeconds;

  ExerciseInProgress(this.elapsedSeconds, this.totalSeconds);
}

class ExerciseCompleted extends ExerciseDetailState {}
