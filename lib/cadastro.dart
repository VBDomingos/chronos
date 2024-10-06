import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:project/tela_login.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Permite que o conteúdo suba com o teclado
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Voltar para a tela de login
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                const SizedBox(height: 20.0),

                // Subtítulo
                const Text(
                  'Crie sua conta',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),

                const Text(
                  'Registre seus dados',
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

                // Campo Nome completo
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nome completo',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Campo CPF
                TextField(
                  controller: cpfController,
                  keyboardType:
                      TextInputType.number, // Apenas números no teclado
                  decoration: InputDecoration(
                    labelText: 'CPF',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Campo Telefone
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone, // Teclado numérico
                  decoration: InputDecoration(
                    labelText: 'Telefone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Campo Código da empresa
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Código da empresa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Botão de criar conta
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Cor preta
                    ),
                    onPressed: () {
                      // Ação de criar conta
                    },
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
