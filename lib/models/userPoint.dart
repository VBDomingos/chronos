import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:project/models/usermodel.dart';
import 'package:provider/provider.dart';

class UserPointModel with ChangeNotifier {
  Future<void> addWorkingTime(BuildContext context, String type) async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    // Formata a data para o formato desejado
    final now = DateTime.now().toUtc();
    final dateKey = DateFormat('dd-MM-yyyy').format(now); // Ex: "26/10/2024"

    try {
      // Adiciona um novo documento na coleção users_points com um ID gerado automaticamente
      await FirebaseFirestore.instance
          .collection('company_users_points')
          .doc(userModel.companyId)
          .collection('users_points')
          .doc(userModel.uid)
          .collection(dateKey)
          .add({
        'type': type,
        'date': now.toIso8601String(), // Armazenando a data em formato ISO 8601
      });
    } catch (e) {
      print('Erro ao adicionar ponto de entrada/saída: $e');
    }
  }
}
