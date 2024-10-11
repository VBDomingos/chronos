import 'package:flutter/material.dart';
import 'package:project/widgets/bottom_nav_bar.dart';
import 'package:project/widgets/header.dart';

void main() {
  runApp(const ConfigPage());
}

class ConfigPage extends StatelessWidget {
  const ConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Header(),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Opções',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              // Notifications toggle
              SettingToggle(
                title: 'Notificações',
                initialValue: true,
                onChanged: (value) {
                  // Handle change
                },
              ),
              const SizedBox(height: 20),
              // Dark Mode toggle
              SettingToggle(
                title: 'Modo Escuro',
                initialValue: false,
                onChanged: (value) {
                  // Handle change
                },
              ),
              const SizedBox(height: 20),
              // Auto-login toggle
              SettingToggle(
                title: 'Login Automático',
                initialValue: true,
                onChanged: (value) {
                  // Handle change
                },
              ),
            ],
          ),
        ),
      
        bottomNavigationBar: CustomBottomNavigationBar(),

      );
  }
}

class SettingToggle extends StatefulWidget {
  final String title;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SettingToggle({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _SettingToggleState createState() => _SettingToggleState();
}

class _SettingToggleState extends State<SettingToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        Switch(
          value: _value,
          onChanged: (newValue) {
            setState(() {
              _value = newValue;
              widget.onChanged(newValue);
            });
          },
          activeColor: Colors.black,
          activeTrackColor: Colors.grey.shade300,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
