import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:project/models/usermodel.dart';
import 'package:provider/provider.dart';

class UserPointModel with ChangeNotifier {
  bool loadingPoint = false;

  Future<void> addWorkingTime(BuildContext context, String type) async {
    this.loadingPoint = true;
    notifyListeners();
    UserModel userModel = Provider.of<UserModel>(context, listen: false);

    // Formata a data para o formato desejado
    final now = DateTime.now();
    final dateKey = DateFormat('dd/MM/yyyy').format(now); // Ex: "26/10/2024"
    final timeKey = DateFormat('HH:mm')
        .format(now.subtract(const Duration(hours: 3))); // Ex: "07:12"

    try {
      // Solicita a permissão de localização, se necessário
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception("Permissão de localização negada.");
      }

      // Obtenha a localização atual
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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
          final filteredKeys = data.keys
              .where((key) =>
                  key.startsWith("entrada-") || key.startsWith("saida-"))
              .toList();

          if (filteredKeys.isNotEmpty) {
            // Ordena as chaves com base no campo de horário dentro de cada registro
            filteredKeys.sort((a, b) {
              final timeA = data[a]['time'] as String;
              final timeB = data[b]['time'] as String;

              return timeA.compareTo(timeB);
            });

            final lastEntry = filteredKeys.last;

            if (lastEntry.startsWith(type)) {
              throw Exception('Erro: Já existe um registro recente de $type.');
            }
          }
        }
      }

      int count = 1;
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          // Conta quantas chaves começam com "entrada-" ou "saida-" dependendo do tipo
          count = data.keys.where((key) => key.startsWith('$type-')).length + 1;
        }
      }

      // Atualiza o documento no Firestore com o horário e localização da marcação
      await docRef.update({
        '$type-$count': {
          'time': timeKey,
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
        }
      });

      print(
          '$type-$count adicionado com sucesso na data $dateKey com localização!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ponto registrado com sucesso!')),
      );
      this.loadingPoint = false;
      notifyListeners();
    } catch (e) {
      print('Erro ao adicionar ponto de entrada/saída: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao adicionar ponto: ${e.toString()}')),
      );
      this.loadingPoint = false;
      notifyListeners();
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
        .doc(userModel.uid)
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
