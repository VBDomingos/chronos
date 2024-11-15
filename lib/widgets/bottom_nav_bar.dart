import 'package:flutter/material.dart';
import 'package:project/models/adm_model.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/views/history.dart';
import 'package:project/views/user_screen.dart';
import 'package:project/views/config_screen.dart';
import 'package:project/views/tela_company.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (userModel.role == 'admin') {
                if (ModalRoute.of(context)?.settings.name != 'CompanyPage') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyPage(),
                      settings: const RouteSettings(
                          name: 'AdmScreen'), // Define o nome da rota
                    ),
                  );
                }
              } else {
                // Verifica se a rota atual já é a UserPage
                if (ModalRoute.of(context)?.settings.name != 'UserScreen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserScreen(),
                      settings: const RouteSettings(
                          name: 'UserScreen'), // Define o nome da rota
                    ),
                  );
                }
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
                    settings: const RouteSettings(
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
