import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/views/config_screen.dart';
import 'package:project/views/tela_login.dart';
import 'package:provider/provider.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = Provider.of<UserModel>(context, listen: false);
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('Users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          userModel?.setUserData(
              userDoc.data()?['name'],
              userDoc.data()?['workingPattern'],
              userDoc.data()?['companyId'],
              userDoc.data()?['uid']);
          await userModel?.setCompanyWorkingTime(context);
        }
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
    }
  }

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
                settings: const RouteSettings(name: 'LoginScreen'),
              ),
            );
            final FirebaseAuth auth = FirebaseAuth.instance;
            auth.signOut();
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: Text(
        userModel?.fullName ??
            'Carregando...', // Exibe o nome do usuário se disponível
        style: const TextStyle(color: Colors.black),
      ),
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
                    builder: (context) => const ConfigPage(),
                    settings: const RouteSettings(
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
