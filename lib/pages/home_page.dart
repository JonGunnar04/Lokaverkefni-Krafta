import 'package:flutter/material.dart';
import 'package:krafta/data/workout_data.dart';
import 'package:krafta/pages/workout_page.dart';
import 'package:provider/provider.dart';

/*
  Heimaskjárinn sýnir lista af æfingaáætlunum og stýrir viðbót nýrra áætlana.

  Sér um að:
  - birta allar æfingaáætlunir í lista
  - sýna glugga til að búa til nýja áætlun
  - fara á æfinga síðu þegar ýtt er á færslu
*/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// Innri klasi sem heldur utan um ástand Heimaskjásins.
class _HomePageState extends State<HomePage> {
  // Stýringarhlutur fyrir innslátt á nafni nýrrar áætlunar
  final newWorkoutNameController = TextEditingController();

  // Opnar samræðuventi til að búa til nýja æfingaáætlun
  void createNewWorkout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Create new workout'),
            content: TextField(controller: newWorkoutNameController),
            actions: [
              // Vista hnappur sendir innslátt áfram
              MaterialButton(onPressed: save, child: Text('Save')),
              // Hætta við lokar glugga án vistunar
              MaterialButton(onPressed: cancel, child: Text('Cancel')),
            ],
          ),
    );
  }

  // Fer á síðu tiltekinnar æfingaáætlunar
  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  // Les nafn nýju áætlunarinnar og bætir henni við gagnagrunn
  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

    // Loka samræðuventi og hreinsa stjórnara
    Navigator.pop(context);
    clear();
  }

  // Hættir við að búa til nýja áætlun og hreinsar stjórnara
  void cancel() {
    Navigator.pop(context);
    clear();
  }

  // Hreinsar textastýringar
  void clear() {
    newWorkoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder:
          (context, value, child) => Scaffold(
            appBar: AppBar(title: Text('Krafta Workout App')),
            floatingActionButton: FloatingActionButton(
              onPressed: createNewWorkout,
              child: Icon(Icons.add),
            ),
            body: ListView.builder(
              itemCount: value.getWorkoutList().length,
              itemBuilder:
                  (context, index) => ListTile(
                    title: Text(value.getWorkoutList()[index].name),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed:
                          () => goToWorkoutPage(
                            value.getWorkoutList()[index].name,
                          ),
                    ),
                  ),
            ),
          ),
    );
  }
}
