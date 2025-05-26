import 'package:hive/hive.dart';

part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  final String weight;
  @HiveField(2)
  final String reps;
  @HiveField(3)
  final String sets;
  @HiveField(4)
  bool isCompleted;

  Exercise({
    required this.name,
    required this.weight,
    required this.reps,
    required this.sets,
    this.isCompleted = false,
  });
}
