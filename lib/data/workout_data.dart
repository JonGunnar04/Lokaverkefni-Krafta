import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:krafta/models/workout.dart';
import 'package:krafta/models/exercise.dart';

class WorkoutData extends ChangeNotifier {
  final Box<Workout> box = Hive.box<Workout>('workoutsBox');
  List<Workout> get workoutList => box.values.toList();

  void addWorkout(String name) {
    final workout = Workout(name: name, exercises: []);
    box.add(workout);
    notifyListeners();
  }

  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    final workout = box.values.firstWhere((w) => w.name == workoutName);
    workout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );
    workout.save();
    notifyListeners();
  }

  void checkOffExercise(String workoutName, String exerciseName) {
    final workout = box.values.firstWhere((w) => w.name == workoutName);
    final ex = workout.exercises.firstWhere((e) => e.name == exerciseName);
    ex.isCompleted = !ex.isCompleted;
    workout.save();
    notifyListeners();
  }

  int numberOfExercisesInWorkout(String workoutName) {
    return box.values.firstWhere((w) => w.name == workoutName).exercises.length;
  }

  Workout getRelevantWorkout(String workoutName) {
    return box.values.firstWhere((w) => w.name == workoutName);
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    final workout = getRelevantWorkout(workoutName);
    return workout.exercises.firstWhere((e) => e.name == exerciseName);
  }

  void deleteWorkout(String workoutName) {
    final workout = getRelevantWorkout(workoutName);
    workout.delete();
    notifyListeners();
  }

  void renameWorkout(String oldName, String newName) {
    final workout = getRelevantWorkout(oldName);
    workout.name = newName;
    workout.save();
    notifyListeners();
  }

  void deleteExercise(String workoutName, String exerciseName) {
    final workout = getRelevantWorkout(workoutName);
    workout.exercises.removeWhere((e) => e.name == exerciseName);
    workout.save();
    notifyListeners();
  }

  void renameExercise(String workoutName, String oldName, String newName) {
    final workout = getRelevantWorkout(workoutName);
    final exercise = workout.exercises.firstWhere((e) => e.name == oldName);
    exercise.name = newName;
    workout.save();
    notifyListeners();
  }
}
