import 'package:hive_flutter/hive_flutter.dart';
import 'package:krafta/models/exercise.dart';
import 'package:krafta/models/workout.dart';

class HiveService {
  static const _boxName = 'workoutsBox';
  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExerciseAdapter());
    Hive.registerAdapter(WorkoutAdapter());
    await Hive.openBox<Workout>(_boxName);
  }

  static Box<Workout> get workoutsBox => Hive.box<Workout>(_boxName);
}