import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/models/userPoint.dart';
import 'package:project/views/correcao_ponto.dart';
import 'package:project/firebaseoptions.dart';
import 'package:project/widgets/dateRangePicker.dart';
import 'package:project/widgets/horasWidget.dart';
import 'package:project/views/tela_login.dart';
import 'package:project/views/user_screen.dart';
import 'package:project/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPage createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  Map<String, String> selectedDateRange = {
    'dataInicial': '',
    'dataFinal': '',
  };

  void _updateDateRange(String dateRange) {
    setState(() {
      selectedDateRange = transformarData(dateRange);
    });
    // Obtenha o UserPointModel do Provider e chame a função desejada
    final userPoint = Provider.of<UserPointModel>(context, listen: false);
    userPoint.calculateTotalHoursWorked(
        context,
        selectedDateRange['dataInicial']!,
        selectedDateRange['dataFinal']!,
        'filterWorkedHours');
  }

  Map<String, String> transformarData(String range) {
    List<String> datas = range.split(' - ');
    return {
      'dataInicial': datas[0],
      'dataFinal': datas[1],
    };
  }

  @override
  Widget build(BuildContext context) {
    final userPoint = Provider.of<UserPointModel>(context);
    return Scaffold(
      backgroundColor: Colors.white, // Define o fundo como branco
      appBar: Header(false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de dia da semana
            DayoftheweekIndicator(),

            const SizedBox(height: 10),

            // Busca de Histórico
            const Text(
              'Busca de Histórico',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Input de range de data
            DateRangePicker(onDateRangeSelected: _updateDateRange),

            const SizedBox(height: 20),

            // Tabela de horas
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(
                            10), // Aplica o border radius apenas no topo
                      ),
                      border:
                          Border.all(color: Colors.grey), // Adiciona a borda
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Período: ${selectedDateRange['dataInicial'] ?? ''} - ${selectedDateRange['dataFinal'] ?? ''}'),
                  )
                ]),
                TableRow(children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Horas Totais Previstas: ${userPoint.balanceFilterExpectedHours ?? ''}'),
                  ),
                ]),
                TableRow(children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Horas Totais Trabalhadas: ${userPoint.balanceFilterWorkedHours ?? ''}'),
                  ),
                ]),
                TableRow(children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(
                            10), // Aplica o border radius apenas no topo
                      ),
                      border: Border(
                        left: BorderSide(color: Colors.grey),
                        right: BorderSide(color: Colors.grey),
                        bottom: BorderSide(color: Colors.grey),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Saldo Total: ${userPoint.balanceFilterHours ?? ''}'),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 17),

            // Tabela com dados de horas
            const Text(
              'Tabela de Horas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: HorasWidget(
                dataInicial: selectedDateRange['dataInicial'] ?? '',
                dataFinal: selectedDateRange['dataFinal'] ?? '',
              ),
            ),
          ],
        ),
      ),

      // Rodapé com botões
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
