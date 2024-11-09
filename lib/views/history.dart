import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/views/correcao_ponto.dart';
import 'package:project/firebaseoptions.dart';
import 'package:project/widgets/horasWidget.dart';
import 'package:project/views/tela_login.dart';
import 'package:project/views/user_screen.dart';
import 'package:project/widgets/bottom_nav_bar.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';

void history() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300], // Global background color
          foregroundColor: Colors.black, // Global text and icon color
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
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '01/07/2022 - 05/12/2022',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Borda quando o campo não está em foco
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors
                              .blueAccent, // Borda quando o campo está em foco
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Função de busca
                  },
                ),
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
            const SizedBox(height: 17),

            // Tabela com dados de horas
            const Text(
              'Tabela de Horas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: HorasWidget(
                dataInicial: "01/11/2024", // Data inicial no formato DD/MM/AAAA
                dataFinal: "10/11/2024", // Data final no formato DD/MM/AAAA
              ), // Usando o widget de tabela
            ),
          ],
        ),
      ),

      // Rodapé com botões
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
