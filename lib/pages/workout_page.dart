import 'package:flutter/material.dart';
import 'package:krafta/components/exercise_tile.dart';
import 'package:krafta/data/workout_data.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  // Stýrir því hvort æfing sé lokið eða ekki
  void onCheckBoxChanged(String workoutName, String exerciseName) {
    // Breytir stöðu æfingarinnar
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).checkOffExercise(workoutName, exerciseName);
  }

  // text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // Stýrir því að ný æfing sé búin til
  void createNewExercise() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Create new exercise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: exerciseNameController,
                  decoration: InputDecoration(hintText: 'Exercise Name'),
                ),
                TextField(
                  controller: weightController,
                  decoration: InputDecoration(hintText: 'Weight'),
                ),
                TextField(
                  controller: repsController,
                  decoration: InputDecoration(hintText: 'Reps'),
                ),
                TextField(
                  controller: setsController,
                  decoration: InputDecoration(hintText: 'Sets'),
                ),
              ],
            ),
            actions: [
              // Vista hnappur sendir innslátt áfram
              MaterialButton(onPressed: save, child: Text('Save')),
              // Hætta við lokar glugga án vistunar
              MaterialButton(onPressed: cancel, child: Text('Cancel')),
            ],
          ),
    );
  }

  void save() {
    String newExerciceName = exerciseNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciceName,
      weightController.text,
      repsController.text,
      setsController.text,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder:
          (context, value, child) => Scaffold(
            appBar: AppBar(title: Text(widget.workoutName)),
            floatingActionButton: FloatingActionButton(
              onPressed: () => createNewExercise(),
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
              itemBuilder:
                  (context, index) => ExerciseTile(
                    exerciseName:
                        value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .name,
                    weight:
                        value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .weight,
                    reps:
                        value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .reps,
                    sets:
                        value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .sets,
                    isCompleted:
                        value
                            .getRelevantWorkout(widget.workoutName)
                            .exercises[index]
                            .isCompleted,
                    onCheckBoxChanged:
                        (val) => onCheckBoxChanged(
                          widget.workoutName,
                          value
                              .getRelevantWorkout(widget.workoutName)
                              .exercises[index]
                              .name,
                        ),
                  ),
            ),
          ),
    );
  }
}
