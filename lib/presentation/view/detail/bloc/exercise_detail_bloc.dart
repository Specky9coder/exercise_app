import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../../lib.dart';

class ExerciseDetailBloc
    extends Bloc<ExerciseDetailEvent, ExerciseDetailState> {
  final int duration;
  Timer? _timer;
  int _elapsed = 0;

  ExerciseDetailBloc(this.duration) : super(ExerciseDetailInitial()) {
    on<StartExercise>((event, emit) {
      _elapsed = 0;
      emit(ExerciseInProgress(_elapsed, duration));
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(Tick());
      });
    });

    on<Tick>((event, emit) {
      _elapsed++;
      if (_elapsed >= duration) {
        _timer?.cancel();
        emit(ExerciseCompleted());
      } else {
        emit(ExerciseInProgress(_elapsed, duration));
      }
    });

    on<ResetExercise>((event, emit) {
      _timer?.cancel();
      _elapsed = 0;
      emit(ExerciseDetailInitial());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
