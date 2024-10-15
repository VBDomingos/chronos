import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:project/views/tela_login.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final fullNameController = TextEditingController();
  final companyCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerUser(BuildContext context) async {
    try {
      // Registrar o usuário com email e senha
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Armazenar informações adicionais no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'nome': fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'cpf': cpfController.text.trim(),
        'telefone': phoneController.text.trim(),
        'codigoEmpresa': companyCodeController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Sucesso - você pode redirecionar o usuário ou mostrar uma mensagem
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Conta criada com sucesso!'),
        backgroundColor: Colors.green,
      ));

      // Redireciona para a tela de login ou outra tela
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

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

                // Campo de senha
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
                const SizedBox(height: 16.0),

                // Campo Nome completo
                TextField(
                  controller: fullNameController,
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
                  controller: companyCodeController,
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
                    onPressed: () async {
                      try {
                        await _registerUser(context);

                        // Sucesso: exibe uma mensagem e redireciona
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Usuário criado com sucesso!'),
                        ));

                        // Redirecionar o usuário para a tela de login após o cadastro bem-sucedido
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('A senha fornecida é muito fraca.'),
                          ));
                        } else if (e.code == 'email-already-in-use') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('A conta já existe para este email.'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Erro: ${e.message}'),
                          ));
                        }
                      } catch (e) {
                        print(e);
                      }
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
