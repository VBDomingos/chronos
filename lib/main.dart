import 'package:flutter/material.dart';
import 'package:project/correcao_ponto.dart';
import 'package:project/tela_login.dart';
import 'package:project/user_screen.dart';
import 'widgets/dotw_indicator.dart';
import 'widgets/header.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],  // Global background color
          foregroundColor: Colors.black,  // Global text and icon color
        ),
    ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white, // Cor do AppBar
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Colors.white, // Cor do BottomAppBar
      ),
    ),
    home: LoginScreen(),
  ));
}

class UserPage extends StatelessWidget {
  final List<Map<String, String>> hoursData = [
    {
      "data": "01/07/2024",
      "previstas": "08:50",
      "trabalhadas": "07:45",
      "intervalo": "00:15",
      "saldo": "00:45",
    },
    {
      "data": "02/07/2024",
      "previstas": "08:00",
      "trabalhadas": "08:00",
      "intervalo": "00:30",
      "saldo": "00:00",
    },
    {
      "data": "03/07/2024",
      "previstas": "08:00",
      "trabalhadas": "06:45",
      "intervalo": "01:00",
      "saldo": "01:15",
    },
    {
      "data": "02/07/2024",
      "previstas": "08:00",
      "trabalhadas": "08:00",
      "intervalo": "00:30",
      "saldo": "00:00",
    },
    {
      "data": "03/07/2024",
      "previstas": "08:00",
      "trabalhadas": "06:45",
      "intervalo": "01:00",
      "saldo": "01:15",
    },
    // Adicione mais linhas conforme necessário
  ];

  UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Define o fundo como branco
      appBar: Header(),
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
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '01/07/2022 - 05/12/2022',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Função de busca
                  },
                )
              ],
            ),
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
                    child: const Text('Período: 01/07/2022 - 05/12/2022'),
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
                    child: const Text('Horas Totais Previstas: 2400:00'),
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
                    child: const Text('Horas Totais Trabalhadas: 2534:00'),
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
                    child: const Text('Horas Totais Abonadas: 00:00'),
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
                    child: const Text('Saldo Total:134:00'),
                  ),
                ]),
              ],
            ),
            const SizedBox(height: 20),

            // Tabela com dados de horas
            const Text(
              'Tabela de Horas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child:
                  HoursTable(hoursData: hoursData), // Usando o widget de tabela
            ),
          ],
        ),
      ),

      // Rodapé com botões
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Ação para Tela Inicial
              },
              icon: const Icon(Icons.home),
              label: const Text('Tela Inicial'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Ação para Tela do Usuário
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserScreen()),
                  );
              },
              icon: const Icon(Icons.person),
              label: const Text('Tela do Usuário'),
            ),
          ],
        ),
      ),
    );
  }
}

class HoursTable extends StatelessWidget {
  final List<Map<String, String>> hoursData;

  const HoursTable({super.key, required this.hoursData});
  // Simulação de dados, como se viessem do Firebase

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2), // Coluna para o ícone de edição
            },
            border: TableBorder.all(color: Colors.grey), // Borda na tabela
            children: [
              // Cabeçalho da tabela
              TableRow(children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Data',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Previstas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Trabalhadas',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Intervalo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    'Saldo',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                ),
              ]),
              // Adicionando linhas dinamicamente a partir do array de dados
              ...List.generate(hoursData.length, (index) {
                final item = hoursData[index];
                return TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item["data"] ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item["previstas"] ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item["trabalhadas"] ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item["intervalo"] ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item["saldo"] ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Ação ao clicar no ícone de edição
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CorrecaoPontoScreen()),
                        );
                      },
                    ),
                  ),
                ]);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
