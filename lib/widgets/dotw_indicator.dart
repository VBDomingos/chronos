import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayoftheweekIndicator extends StatelessWidget {
  const DayoftheweekIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dayOfWeek = today.weekday - 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (index) {
            final isSelected = index == dayOfWeek;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                radius: 5,
                backgroundColor: isSelected ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            DateFormat('EEEE | dd/MM/yyyy')
                .format(today), // Nome completo do dia em português
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
