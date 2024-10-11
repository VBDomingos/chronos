import 'package:flutter/material.dart';
import 'package:project/cadastro.dart';
import 'package:project/main.dart';
import 'package:project/tela_company.dart';
import 'package:project/user_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título principal
              const Text(
                'CronosPoint',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),

              // Subtítulo
              const Text(
                'Faça seu login',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8.0),

              const Text(
                'Coloque seu e-mail e senha',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),

              // Campo de email
              TextField(
                decoration: InputDecoration(
                  labelText: 'email@domain.com',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16.0),

              // Campo de senha
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 24.0),

              // Botão de login
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Cor preta
                  ),
                  onPressed: () {
                    // Ação de login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserScreen(),
                          settings: RouteSettings(
                            name: 'UserScreen',
                          )),
                    );
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Cor preta
                  ),
                  onPressed: () {
                    // Ação de login
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CompanyPage()),
                    );
                  },
                  child: const Text(
                    'Login Empresa',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Texto sobre criar conta
              const Text(
                'caso não possua conta clique abaixo',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),

              // Botão de criar conta
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300], // Cor cinza claro
                  ),
                  onPressed: () {
                    // Navega para a tela de registro
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Termos de serviço e política de privacidade
              const Text(
                'By clicking continue, you agree to our Terms of Service and Privacy Policy',
                style: TextStyle(fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
