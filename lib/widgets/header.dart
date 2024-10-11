import 'package:flutter/material.dart';
import 'package:project/config_screen.dart';
import 'package:project/tela_login.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      leading: IconButton(
        icon: const Icon(Icons.logout),
        onPressed: () {
          if (ModalRoute.of(context)?.settings.name != 'LoginScreen') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginScreen(),
                settings:
                    RouteSettings(name: 'LoginScreen'), // Define o nome da rota
              ),
            );
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Text('Nome do UsuEmpresa'),
      centerTitle: true,
      actions: [
        if (ModalRoute.of(context)?.settings.name != 'CorrecaoPontoScreen')
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != 'ConfigPage') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfigPage(),
                    settings: RouteSettings(
                        name: 'ConfigPage'), // Define o nome da rota
                  ),
                );
              }
            },
          ),
        if (ModalRoute.of(context)?.settings.name != 'ConfigPage' &&
            ModalRoute.of(context)?.settings.name != 'CorrecaoPontoScreen')
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Função de refresh aqui
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
