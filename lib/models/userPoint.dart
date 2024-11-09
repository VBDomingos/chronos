import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/models/usermodel.dart';
import 'package:provider/provider.dart';

class UserPointModel with ChangeNotifier {
  Future<void> addWorkingTime(BuildContext context, String type) async {
    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    // Formata a data para o formato desejado
    final now = DateTime.now();
    final dateKey = DateFormat('dd/MM/yyyy').format(now); // Ex: "26/10/2024"
    final timeKey = DateFormat('HH:mm')
        .format(now.subtract(const Duration(hours: 3))); // Ex: "07:12"

    try {
      // Referência para a coleção de registros de tempo do usuário
      final timeRecordsRef = FirebaseFirestore.instance
          .collection('employees')
          .doc(userModel.uid)
          .collection('timeRecords');

      // Consulta para encontrar o documento de hoje
      final snapshot =
          await timeRecordsRef.where('date', isEqualTo: dateKey).get();

      DocumentReference<Map<String, dynamic>> docRef;

      if (snapshot.docs.isEmpty) {
        docRef = await timeRecordsRef.add({
          'date': dateKey,
        });
      } else {
        docRef = snapshot.docs.first.reference;
      }

      // Recupera o documento atual
      final docSnapshot = await docRef.get();

      // Verifica o último tipo de ponto registrado
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Filtra apenas as chaves que correspondem ao tipo "entrada-" ou "saida-"
          final filteredKeys =
              data.keys.where((key) => key.startsWith(type)).toList();

          if (filteredKeys.isNotEmpty) {
            // Ordena as chaves para obter o último registro
            filteredKeys.sort();
            final lastEntry = filteredKeys.last;

            // Se o último registro for do mesmo tipo, lança um erro
            if (lastEntry.startsWith(type)) {
              throw Exception('Erro: Já existe um registro recente de $type.');
            }
          }
        }
      }

      // Conta quantas entradas ou saídas já existem no documento
      int count = 1;
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Conta quantas chaves começam com "entrada-" ou "saida-" dependendo do tipo
          count = data.keys.where((key) => key.startsWith('$type-')).length + 1;
        }
      }

      await docRef.update({
        '$type-$count': timeKey,
      });

      print('$type-$count adicionado com sucesso na data $dateKey!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ponto registrado com sucesso!')),
      );
    } catch (e) {
      print('Erro ao adicionar ponto de entrada/saída: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar ponto: ${e.toString()}')),
      );
    }
  }

  Future<void> confirmAndAddWorkingTime(
      BuildContext context, String type) async {
    // Mostra o diálogo de confirmação
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar $type'),
          content: Text('Tem certeza de que deseja registrar uma $type agora?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Usuário cancelou
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Usuário confirmou
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    // Se o usuário confirmou, chama a função para registrar o ponto
    if (confirm == true) {
      await addWorkingTime(context, type);
    }
  }

  Future<void> confirmAndRequestChangeWorkingTime(BuildContext context,
      reasonController, timeController, hora, originalKey) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Solicitação'),
          content: Text('Tem certeza de que deseja solicitar a mudança?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Usuário cancelou
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Usuário confirmou
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    // Se o usuário confirmou, chama a função para registrar o ponto
    if (confirm == true) {
      await requestChangeWorkingTime(
          context, reasonController, timeController, hora, originalKey);
    }
  }

  Future<void> requestChangeWorkingTime(
      context, reasonController, timeController, hora, originalKey) async {
    if (reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Justificativa é obrigatória.')),
      );
      return;
    }
    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    final solicitationsRef = FirebaseFirestore.instance
        .collection('employees')
        .doc(userModel.uid) // Replace with actual user ID
        .collection('solicitations');

    await solicitationsRef.add({
      'newValue': timeController.text,
      'previousValue': hora,
      'reason': reasonController.text,
      'requestField': originalKey,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Solicitação enviada com sucesso!')),
    );

    Navigator.pop(context);
  }
}
