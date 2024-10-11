import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context); 
        },
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: const Text('Nome do UsuEmpresa'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            // refresh functionality here
          },
        ),
      ],
    );
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
