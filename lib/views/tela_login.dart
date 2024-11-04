import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:project/views/cadastro.dart';
import 'package:project/views/user_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _login(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserScreen(),
          settings: const RouteSettings(name: 'UserScreen'),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'O endereço de e-mail fornecido é inválido.';
          break;
        case 'user-disabled':
          errorMessage = 'Esta conta foi desativada. Entre em contato com o suporte.';
          break;
        case 'user-not-found':
          errorMessage = 'Nenhuma conta encontrada com este e-mail.';
          break;
        case 'wrong-password':
          errorMessage = 'Senha incorreta. Tente novamente.';
          break;
        default:
          errorMessage = 'Erro inesperado. Tente novamente mais tarde.';
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Use sua digital para fazer login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      // Navigate to UserScreen on successful biometric authentication
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const UserScreen(),
          settings: const RouteSettings(name: 'UserScreen'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Autenticação biométrica falhou')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'CronosPoint',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Faça seu login',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24.0),

              TextField(
                controller: _emailController,
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

              TextField(
                controller: _passwordController,
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

              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    await _login(context);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Button for biometric login
              SizedBox(
                height: 50.0,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    await _authenticateWithBiometrics(context);
                  },
                  icon: const Icon(Icons.fingerprint),
                  label: const Text(
                    'Login com Biometria',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              const Text(
                'caso não possua conta clique abaixo',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),

              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                  ),
                  onPressed: () {
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
