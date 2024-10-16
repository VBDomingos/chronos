import 'package:flutter/material.dart';
import 'package:project/views/history.dart';
import 'package:project/views/user_screen.dart';
import 'package:project/views/config_screen.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              // Verifica se a rota atual já é a UserPage
              if (ModalRoute.of(context)?.settings.name != 'UserScreen') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserScreen(),
                    settings: RouteSettings(
                        name: 'UserScreen'), // Define o nome da rota
                  ),
                );
              }
            },
            icon: const Icon(Icons.home),
            label: const Text('Tela Inicial'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Verifica se a rota atual já é a UserPage
              if (ModalRoute.of(context)?.settings.name != 'UserPage') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserPage(),
                    settings: RouteSettings(
                        name: 'UserPage'), // Define o nome da rota
                  ),
                );
              }
            },
            icon: const Icon(Icons.person),
            label: const Text('Tela do Usuário'),
          ),
        ],
      ),
    );
  }
}
