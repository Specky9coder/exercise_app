import 'package:bloc/bloc.dart';

import '../../../../lib.dart';

class ExerciseListBloc extends Bloc<ExerciseListEvent, ExerciseListState> {
  final ExerciseRepository repository;
  final LocalStorage localStorage;

  List<Exercise> _exercises = [];
  Set<String> _completedIds = {};
  int continuousDays = 0;

  ExerciseListBloc(this.repository, this.localStorage)
      : super(ExerciseListInitial()) {
    // on<LoadExercises>((event, emit) async {
    //   emit(ExerciseListLoading());
    //   try {
    //     _exercises = await repository.fetchExercises();
    //     _completedIds = await localStorage.getCompletedExercises();
    //
    //     // Load sets data
    //     final setsMap = await localStorage.getSetsData();
    //
    //     // Mark completed and set sets
    //     for (var e in _exercises) {
    //       e.completed = _completedIds.contains(e.id);
    //       e.setsCompleted = setsMap[e.id] ?? 0;
    //     }
    //
    //     await _updateProgress();
    //     emit(ExerciseListLoaded(List.from(_exercises), continuousDays));
    //   } catch (e) {
    //     emit(ExerciseListError(e.toString()));
    //   }
    // });

    /// it is working

    // on<LoadExercises>((event, emit) async {
    //   emit(ExerciseListLoading());
    //   try {
    //     _exercises = await repository.fetchExercises();
    //     _completedIds = await localStorage.getCompletedExercises();
    //     final setsData = await localStorage.getSetsData();
    //     final todayStr = _dateToString(DateTime.now());
    //
    //     for (var e in _exercises) {
    //       e.completed = _completedIds.contains(e.id);
    //       e.setsCompleted = setsData[todayStr]?[e.id] ?? 0;
    //     }
    //
    //     await _updateProgress();
    //
    //     emit(ExerciseListLoaded(List.from(_exercises), continuousDays));
    //   } catch (e) {
    //     emit(ExerciseListError(e.toString()));
    //   }
    // });

    on<LoadExercises>((event, emit) async {
      emit(ExerciseListLoading());
      try {
        _exercises = await repository.fetchExercises();
        final todayStr = _dateToString(DateTime.now());

        final setsData = await localStorage.getSetsData();
        final todaySets = setsData[todayStr] ?? {};

        for (var e in _exercises) {
          e.completed = todaySets.containsKey(e.id);
          e.setsCompleted = todaySets[e.id] ?? 0;
        }

        await _updateProgress();

        emit(ExerciseListLoaded(List.from(_exercises),  continuousDays));
      } catch (e) {
        emit(ExerciseListError(e.toString()));
      }
    });


    // on<MarkExerciseCompleted>((event, emit) async {
    //   _completedIds.add(event.exerciseId);
    //   await localStorage.saveCompletedExercises(_completedIds);
    //
    //   final index = _exercises.indexWhere((e) => e.id == event.exerciseId);
    //   if (index != -1) {
    //     _exercises[index].completed = true;
    //     _exercises[index].setsCompleted++;
    //     await localStorage.saveSetsData(
    //         _exercises[index].id, _exercises[index].setsCompleted);
    //   }
    //
    //   await _updateProgress();
    //   emit(ExerciseListLoaded(List.from(_exercises), continuousDays));
    // });

    on<MarkExerciseCompleted>((event, emit) async {
      _completedIds.add(event.exerciseId);
      await localStorage.saveCompletedExercises(_completedIds);

      final index = _exercises.indexWhere((e) => e.id == event.exerciseId);
      if (index != -1) {
        _exercises[index].completed = true;
        _exercises[index].setsCompleted++;
      }

      // Save sets completed for today
      final setsData = await localStorage.getSetsData();
      final todayStr = _dateToString(DateTime.now());
      setsData.putIfAbsent(todayStr, () => {});
      setsData[todayStr]![event.exerciseId] = _exercises[index].setsCompleted;
      await localStorage.saveSetsData(setsData);

      await _updateProgress();

      emit(ExerciseListLoaded(List.from(_exercises),  continuousDays));
    });


  }

  Future<void> _updateProgress() async {
    List<String> dates = await localStorage.getCompletedDates();

    final today = DateTime.now();
    final todayStr = _dateToString(today);

    if (!dates.contains(todayStr)) {
      dates.add(todayStr);
      await localStorage.saveCompletedDates(dates);
    }

    dates.sort((a, b) => b.compareTo(a));
    continuousDays = _calculateContinuousDays(dates);
  }

  int _calculateContinuousDays(List<String> dates) {
    if (dates.isEmpty) return 0;

    DateTime prevDate = DateTime.parse(dates[0]);
    int count = 1;

    for (int i = 1; i < dates.length; i++) {
      final date = DateTime.parse(dates[i]);
      if (prevDate.difference(date).inDays == 1) {
        count++;
        prevDate = date;
      } else {
        break;
      }
    }
    return count;
  }

  String _dateToString(DateTime dt) => dt.toIso8601String().split('T').first;
}
