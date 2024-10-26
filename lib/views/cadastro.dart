import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:project/views/tela_login.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final phoneController = MaskedTextController(mask: '(00) 00000-0000');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedWorkingPattern;

  final fullNameController = TextEditingController();
  final companyCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerUser(BuildContext context) async {
    try {
      // Registro com email e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Armazenar informações adicionais no Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'cpf': cpfController.text.trim(),
        'telefone': phoneController.text.trim(),
        'companyId': companyCodeController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'employee',
        'workingPattern': selectedWorkingPattern,
        'uid': userCredential.user!.uid,
      });

      // Mensagem de sucesso e redirecionamento
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage =
              'A senha fornecida é muito fraca. Tente outra senha mais segura.';
          break;
        case 'email-already-in-use':
          errorMessage =
              'Este email já está em uso. Tente fazer login ou utilize outro email.';
          break;
        case 'invalid-email':
          errorMessage =
              'O email fornecido é inválido. Verifique o endereço e tente novamente.';
          break;
        default:
          errorMessage = 'Erro inesperado: ${e.message}';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro inesperado. Tente novamente mais tarde.'),
          backgroundColor: Colors.red,
        ),
      );
      print(e); // Log do erro para debug
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
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Dropdown para o padrão de trabalho
                DropdownButtonFormField<String>(
                  value: selectedWorkingPattern,
                  onChanged: (String? newValue) {
                    // Atualiza o estado com a nova seleção
                    setState(() {
                      selectedWorkingPattern = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'fulltime',
                      child: Text('Escala cheia (8 horas)'),
                    ),
                    DropdownMenuItem(
                      value: 'halftime',
                      child: Text('Meia escala (4 horas)'),
                    ),
                    DropdownMenuItem(
                      value: 'free',
                      child: Text('Escala livre'),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Padrão de trabalho',
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
                    onPressed: () async => await _registerUser(context),
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
