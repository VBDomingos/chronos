import 'package:flutter/material.dart';
import '../widgets/circular_progress_painter.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav_bar.dart';

class CompanyPage extends StatelessWidget {
  const CompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Indicador de dia da semana
              DayoftheweekIndicator(),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CustomCircularProgress(),
                const SizedBox(width: 30.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.green, width: 2.0),
                      ),
                      child: const Text(
                        'Trabalhando',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.yellow, width: 2.0),
                      ),
                      child: const Text(
                        'A Iniciar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.red, width: 2.0),
                      ),
                      child: const Text(
                        'Em Falta',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.blue, width: 2.0),
                      ),
                      child: const Text(
                        'Ausente',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ]),

              const SizedBox(height: 20.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Completou Jorn.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SummaryBox(color: Colors.green, value: '03'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Atrasado',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SummaryBox(color: Colors.red, value: '01'),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Em Pausa',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SummaryBox(color: Colors.blue, value: '02'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar Funcionário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              Column(
                children: [
                  EmployeeStatusRow(status: 'Em Pausa', color: Colors.blue),
                  const Divider(height: 2.0),
                  EmployeeStatusRow(status: 'Trabalhando', color: Colors.green),
                  const Divider(height: 2.0),
                  EmployeeStatusRow(status: 'Trabalhando', color: Colors.green),
                  const Divider(height: 2.0),
                  EmployeeStatusRow(status: 'Faltou', color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class SummaryBox extends StatelessWidget {
  final Color color;
  final String value;

  const SummaryBox({super.key, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 2.0),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

class EmployeeStatusRow extends StatelessWidget {
  final String status;
  final Color color;

  const EmployeeStatusRow(
      {super.key, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Funcionário'),
      trailing: Text(
        status,
        style: TextStyle(color: color, fontSize: 16),
      ),
    );
  }
}
