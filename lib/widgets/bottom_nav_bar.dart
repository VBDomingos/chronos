import 'package:flutter/material.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/views/history.dart';
import 'package:project/views/user_screen.dart';
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
                          name: 'CompanyPage'),
                    ),
                  );
                }
              } else {
                if (ModalRoute.of(context)?.settings.name != 'UserScreen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserScreen(),
                      settings: const RouteSettings(
                          name: 'UserScreen'),
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
              if (userModel.role == 'admin') {
                if (ModalRoute.of(context)?.settings.name != 'UserScreen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserScreen(),
                      settings: const RouteSettings(
                          name: 'UserScreen'),
                    ),
                  );
                }
              } else {
                if (ModalRoute.of(context)?.settings.name != 'HistoryScreen') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(),
                      settings: const RouteSettings(
                          name: 'HistoryScreen'),
                    ),
                  );
                }
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
