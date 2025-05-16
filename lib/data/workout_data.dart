import 'package:krafta/models/exercise.dart';
import 'package:krafta/models/workout.dart';
import 'package:flutter/foundation.dart';

/*
Klasi sem heldur utan um og stýrir lista af æfingaáætlanum (Workout).

Sér um að:
  - halda skrá yfir allar æfingaáætlanir
  - bæta nýjum áætlunum við
  - bæta æfingum við tilteknar áætlanir
  - skrá loknar æfingar
  - tilkynna áhorfendur um breytingar með notifyListeners()
*/

class WorkoutData extends ChangeNotifier {
  List<Workout> workoutList = [
    // sjálfgefna æfingaáætlunin
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

  /// Skilar núverandi lista af æfingaáætlunum
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  /// Bætir við nýrri æfingaáætlun með nafni
  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
  }

  /// Bætir æfingu með [exerciseName], [weight], [reps] og [sets] við áætlunina [workoutName]
  void addExercise(
    String workoutName,
    String exerciseName,
    String weight,
    String reps,
    String sets,
  ) {
    // Finna rétta æfingaáætlun
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets),
    );
    notifyListeners();
  }

  /// Breytir stöðu æfingar lokið/ólokuð
  void checkOffExercise(String workoutName, String exerciseName) {
    // Finna þá æfingu sem á að merkja
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
  }

  /// Skilar fjölda æfinga í áætluninni
  int numberOfExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  /// Finnur og skilar æfingaáætlun með nafni
  Workout getRelevantWorkout(String workoutName) {
    return workoutList.firstWhere((workout) => workout.name == workoutName);
  }

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.firstWhere(
      (exercise) => exercise.name == exerciseName,
    );
  }
}
