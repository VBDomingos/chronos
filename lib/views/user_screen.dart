import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/dotw_indicator.dart';
import '../widgets/header.dart';
import '../widgets/bottom_nav_bar.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: Header(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DayoftheweekIndicator(), // The day of the week indicator

              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.login, size: 40),
                      const SizedBox(height: 4),
                      const Text("Entrada"),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("8:20"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.free_breakfast, size: 40),
                      const SizedBox(height: 4),
                      const Text("Pausa"),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("12:00"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.computer, size: 40),
                      const SizedBox(height: 4),
                      const Text("Retorno"),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.yellow, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("13:00"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.logout, size: 40),
                      const SizedBox(height: 4),
                      const Text("Saída"),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.red, width: 2.0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("18:00"),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.green, width: 2.0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text("Jornada do Dia"),
                        ),
                        const Text("8:20 - 18:00 | 1h", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Banco de Horas", style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text("00:20"),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Mês vigente", style: TextStyle(fontWeight: FontWeight.bold)),
                            const Text("05/11/2024"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 40),
                        const SizedBox(width: 10),
                        Text(DateFormat('H:mm').format(DateTime.now()), style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                      ]
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                            minimumSize: const Size(150, 50)),
                          child: const Text(
                            "Entrada",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                            minimumSize: const Size(150, 50)),
                          child: const Text(
                            "Saída",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(height: 20),


              TextField(
                decoration: InputDecoration(
                  labelText: "Observações",
                  hintText: "Opcional",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                maxLines: 3,
              ),
                ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
      );
  }
}
