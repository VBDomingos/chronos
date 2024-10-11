import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DayoftheweekIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(7, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CircleAvatar(
                radius: 5,
                backgroundColor: index == 2
                    ? Colors.blue
                    : Colors.grey,
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            DateFormat('EEE | dd/MM/yyyy').format(DateTime.now()),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
