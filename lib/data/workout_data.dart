import 'package:krafta/models/exercise.dart';
import 'package:krafta/models/workout.dart';
import 'package:flutter/foundation.dart';

class WorkoutData extends ChangeNotifier {
  /*

    WORKOUT DATA STRUCTURE

    - This overall list contains the different workouts
    - Each workout has a name and a list of exercises

*/

  List<Workout> workoutList = [
    // default workout
    Workout(
      name: 'Upper Body',
      exercises: [
        Exercise(name: 'Bench Press', weight: '50', reps: '10', sets: '3'),
      ],
    ),
    Workout(
      name: 'Lower Body',
      exercises: [Exercise(name: 'Squat', weight: '60', reps: '10', sets: '3')],
    ),
  ];

  // get the workout list
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // add a new workout
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
  }

  // add an exercise to a workout

  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );
    notifyListeners();
  }

  // check off an exercise

  void checkOffExercise(String workoutName, String exerciseName) {
    // find the relevant exercise
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    // check off the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
  }

  // getting the length of the workout
  int numberOfExercisesInWorkout(String workoutName) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // return the length of the workout
    return relevantWorkout.exercises.length;
  }

  // return the relevant workout given the workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = workoutList.firstWhere(
      (workout) => workout.name == workoutName,
    );

    return relevantWorkout;
  }

  // return the relevant exercise given the workout name and exercise name
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    // find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    // find the relevant exercise
    Exercise relevantExercise = relevantWorkout.exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
    );

    return relevantExercise;
  }
}
