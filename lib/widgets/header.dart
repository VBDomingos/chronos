import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/config_screen.dart';
import 'package:project/views/tela_login.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  @override
  _HeaderState createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  String? fullName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Pega o usuário atual autenticado
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Busca o documento do Firestore baseado no UID do usuário
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            // Atualiza o nome do usuário
            fullName = userDoc.data()?['nome'];
          });
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
            final FirebaseAuth _auth = FirebaseAuth.instance;
            _auth.signOut();
          }
        },
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: Text(
        fullName ?? 'Nome do Usuario', // Exibe o nome do usuário se disponível
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
