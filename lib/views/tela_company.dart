import 'package:flutter/material.dart';
import '../widgets/circular_progress_painter.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav_bar.dart';

class CompanyPage extends StatelessWidget {
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              CustomCircularProgress(),
              const SizedBox(width: 30.0),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.green, width: 2.0),
                    ),
                    child: Text(
                      'Trabalhando',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 4.0),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.yellow, width: 2.0),
                    ),
                    child: Text(
                      'A Iniciar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.red, width: 2.0),
                    ),
                    child: Text(
                      'Em Falta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4.0),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.blue, width: 2.0),
                    ),
                    child: Text(
                      'Ausente',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),

            ]
          ),

          const SizedBox(height: 20.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    'Completou Jorn.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SummaryBox(color: Colors.green, value: '03'),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Atrasado',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SummaryBox(color: Colors.red, value: '01'),
                ],
              ),
              Column(
                children: [
                  Text(
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
              prefixIcon: Icon(Icons.search),
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
              Divider(height: 2.0),
              EmployeeStatusRow(status: 'Trabalhando', color: Colors.green),
              Divider(height: 2.0),
              EmployeeStatusRow(status: 'Trabalhando', color: Colors.green),
              Divider(height: 2.0),
              EmployeeStatusRow(status: 'Faltou', color: Colors.red),
            ],
          ),
        ],
      ),
    ),
  ),
  bottomNavigationBar: CustomBottomNavigationBar(),
);
}
}

class SummaryBox extends StatelessWidget {
  final Color color;
  final String value;

  SummaryBox({required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 2.0),
      ),
      child: Center(
        child: Text(
          value,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}

class EmployeeStatusRow extends StatelessWidget {
  final String status;
  final Color color;

  EmployeeStatusRow({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Funcionário'),
      trailing: Text(
        status,
        style: TextStyle(color: color, fontSize: 16),
      ),
    );
  }
}
