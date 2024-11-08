import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/models/companyWorkingPattern.dart';
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
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('employees')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final name = userDoc.data()?['name'];
          final companyId = userDoc.data()?['companyId'];
          final workingPattern = userDoc.data()?['workingPattern'];

          Provider.of<UserModel>(context, listen: false)
              .setUserData(name, user.uid, companyId, workingPattern);
          Provider.of<CompanyWorkingPatternModel>(context, listen: false)
              .setWorkingPattern(companyId!, workingPattern!);

          setState(() {});
        }
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta mudanças no `UserModel`
    userModel = Provider.of<UserModel>(context);

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
        userModel?.fullName ?? 'Carregando...',
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
                    settings: const RouteSettings(name: 'ConfigPage'),
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
              _fetchUserData(); // Função de refresh
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
