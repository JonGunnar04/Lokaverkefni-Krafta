import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:krafta/components/exercise_tile.dart';
import 'package:krafta/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController setsController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    weightController.dispose();
    repsController.dispose();
    setsController.dispose();
    super.dispose();
  }

  void toggleExercise(String exerciseName) {
    Provider.of<WorkoutData>(
      context,
      listen: false,
    ).checkOffExercise(widget.workoutName, exerciseName);
  }

  void openNewExerciseDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Add an Exercise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Exercise Name'),
                ),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(hintText: 'Weight'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: repsController,
                  decoration: const InputDecoration(hintText: 'Reps'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: setsController,
                  decoration: const InputDecoration(hintText: 'Sets'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: cancel, child: const Text('Cancel')),
              ElevatedButton(
                onPressed: saveExercise,
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void saveExercise() {
    final name = nameController.text.trim();
    if (name.isEmpty) return;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      name,
      weightController.text.trim(),
      repsController.text.trim(),
      setsController.text.trim(),
    );
    Navigator.of(context).pop();
    clearFields();
  }

  void clearFields() {
    nameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void cancel() {
    Navigator.of(context).pop();
    clearFields();
  }

  void showEditExerciseDialog(String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Rename Exercise'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    Provider.of<WorkoutData>(
                      context,
                      listen: false,
                    ).renameExercise(widget.workoutName, oldName, newName);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder:
          (context, data, child) => Scaffold(
            appBar: AppBar(
              title: Text(
                widget.workoutName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.grey[800],
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: openNewExerciseDialog,
              child: const Icon(Icons.add),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 150, 150, 150),
                    Color.fromARGB(255, 81, 81, 81),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: data.numberOfExercisesInWorkout(widget.workoutName),
                itemBuilder: (context, index) {
                  final exercise =
                      data
                          .getRelevantWorkout(widget.workoutName)
                          .exercises[index];
                  return Dismissible(
                    key: ValueKey('${widget.workoutName}-$index'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      data.deleteExercise(widget.workoutName, exercise.name);
                    },
                    child: GestureDetector(
                      onLongPress: () => showEditExerciseDialog(exercise.name),
                      child: ExerciseTile(
                        exerciseName: exercise.name,
                        weight: exercise.weight,
                        reps: exercise.reps,
                        sets: exercise.sets,
                        isCompleted: exercise.isCompleted,
                        onCheckBoxChanged: (_) => toggleExercise(exercise.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
    );
  }
}
