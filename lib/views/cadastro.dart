import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _firestore
          .collection('employees')
          .doc(userCredential.user!.uid)
          .set({
        'name': fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'document': cpfController.text.trim(),
        'phone': phoneController.text.trim(),
        'companyId': companyCodeController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'role': 'employee',
        'workingPattern': selectedWorkingPattern,
      });

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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
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
                const Text(
                  'CronosPoint',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
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
                const SizedBox(height: 16.0),
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
                TextField(
                  controller: cpfController,
                  keyboardType: TextInputType.number,
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
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
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
                DropdownButtonFormField<String>(
                  value: selectedWorkingPattern,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedWorkingPattern = newValue;
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'clt',
                      child: Text('CLT'),
                    ),
                    DropdownMenuItem(
                      value: 'estagio',
                      child: Text('Estágio'),
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
                SizedBox(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () async => await _registerUser(context),
                    child: const Text(
                      'Criar conta',
                      style: TextStyle(color: Colors.white),
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
      ),
    );
  }
}
