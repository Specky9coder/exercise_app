import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../lib.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("🏋️ Exercise Tracker"),
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<ExerciseListBloc, ExerciseListState>(
        builder: (context, state) {
          if (state is ExerciseListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExerciseListError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is ExerciseListLoaded) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.deepOrange),
                      const SizedBox(width: 8),
                      Text(
                        'Streak: ${state.continuousDays} day(s)',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.exercises.length,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemBuilder: (context, index) {
                      final exercise = state.exercises[index];
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                          title: Text(exercise.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${exercise.duration} sec • ${exercise.difficulty}'),
                              Text('Sets done: ${exercise.setsCompleted}',
                                  style: const TextStyle(color: Colors.green)),
                            ],
                          ),
                          trailing: Icon(
                            exercise.completed
                                ? Icons.check_circle
                                : Icons.play_circle_fill,
                            color: exercise.completed
                                ? Colors.green
                                : Colors.deepPurple,
                            size: 28,
                          ),
                          onTap: () async {
                            final completed = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ExerciseDetailScreen(exercise: exercise),
                              ),
                            );
                            if (completed == true) {
                              context
                                  .read<ExerciseListBloc>()
                                  .add(MarkExerciseCompleted(exercise.id));
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
