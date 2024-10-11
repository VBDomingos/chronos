import 'package:flutter/material.dart';
import 'package:project/user_screen.dart';
import 'package:project/config_screen.dart';


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
              // Navigate to HomeScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfigPage(),
                ),
              );
            },
            icon: const Icon(Icons.home),
            label: const Text('Tela Inicial'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to UserScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person),
            label: const Text('Tela do Usuário'),
          ),
        ],
      ),
    );
  }
}
