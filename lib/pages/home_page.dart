import 'package:flutter/material.dart';
import 'package:krafta/data/workout_data.dart';
import 'package:krafta/pages/workout_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newWorkoutNameController = TextEditingController();

  void createNewWorkout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create a New Workout'),
            content: TextField(controller: newWorkoutNameController),
            actions: [
              MaterialButton(onPressed: save, child: const Text('Save')),
              MaterialButton(onPressed: cancel, child: const Text('Cancel')),
            ],
          ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  void save() {
    final newWorkoutName = newWorkoutNameController.text;
    if (newWorkoutName.isNotEmpty) {
      Provider.of<WorkoutData>(
        context,
        listen: false,
      ).addWorkout(newWorkoutName);
    }
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void showEditWorkoutDialog(BuildContext ctx, String oldName) {
    final controller = TextEditingController(text: oldName);
    showDialog(
      context: ctx,
      builder:
          (_) => AlertDialog(
            title: const Text('Rename workout'),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    Provider.of<WorkoutData>(
                      ctx,
                      listen: false,
                    ).renameWorkout(oldName, newName);
                  }
                  Navigator.pop(ctx);
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
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
          (context, value, child) => Scaffold(
            appBar: AppBar(
              title: const Text(
                'Krafta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.grey[800],
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
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
                itemCount: value.workoutList.length,
                itemBuilder: (context, index) {
                  final workout = value.workoutList[index];
                  return Dismissible(
                    key: ValueKey(workout.key),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      value.deleteWorkout(workout.name);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        title: Text(
                          workout.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                        onLongPress:
                            () => showEditWorkoutDialog(context, workout.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios),
                          onPressed: () => goToWorkoutPage(workout.name),
                        ),
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
