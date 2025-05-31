import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;

  const ExerciseTile({
    super.key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8),
        title: Text(exerciseName, style: TextStyle(fontSize: 18)),
        subtitle: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Chip(label: Text('Weight: $weight kg')),
              const SizedBox(width: 6),
              Chip(label: Text('Reps: $reps')),
              const SizedBox(width: 6),
              Chip(label: Text('Sets: $sets')),
            ],
          ),
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}
