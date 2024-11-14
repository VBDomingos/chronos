import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:project/models/usermodel.dart';
import 'package:provider/provider.dart';

class UserPointModel with ChangeNotifier {
  bool loadingPoint = false;
  String? balanceMonthHours;
  String? balanceFilterWorkedHours;
  String? balanceFilterExpectedHours;
  String? balanceFilterHours;

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
          count = data.keys.where((key) => key.startsWith('$type-')).length + 1;
        }
      }

      // Atualiza o documento no Firestore com o horário e localização da marcação
      await docRef.update({
        '$type-$count': {
          'time': timeKey,
          'latitude': currentPosition.latitude,
          'longitude': currentPosition.longitude,
          'solicitationsOpen': false,
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
      reasonController, timeController, date, hora, originalKey) async {
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
          context, reasonController, timeController, date, hora, originalKey);
    }
  }

  Future<void> requestChangeWorkingTime(context, reasonController,
      timeController, date, hora, originalKey) async {
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
      'requestFieldDate': date,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    final timeRecordsRef = FirebaseFirestore.instance
        .collection('employees')
        .doc(userModel.uid)
        .collection('timeRecords')
        .where('date', isEqualTo: date);

    final querySnapshot = await timeRecordsRef.get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({
        '$originalKey.solicitationsOpen': true,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Solicitação enviada com sucesso!')),
    );

    Navigator.pop(context);
  }

  Future<void> calculateTotalHoursWorked(
      context, String startDate, String endDate, String type) async {
    resetValues();
    UserModel userModel = Provider.of<UserModel>(context, listen: false);
    final dateFormatter = DateFormat("dd/MM/yyyy");

    DateTime start = dateFormatter.parse(startDate);
    DateTime end = dateFormatter.parse(endDate);

    Duration totalWorkedDuration = Duration.zero;

    // Calculate total worked hours from timeRecords
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('employees')
          .doc(userModel.uid)
          .collection('timeRecords')
          .where('date', isGreaterThanOrEqualTo: dateFormatter.format(start))
          .where('date', isLessThanOrEqualTo: dateFormatter.format(end))
          .get();

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();

        data.forEach((key, value) {
          if (key.startsWith('entrada-') && value is Map<String, dynamic>) {
            String entryTime = value['time'] ?? '00:00';
            String entryNumber = key.split('-')[1];
            String? exitTime = data['saida-$entryNumber']?['time'];

            if (exitTime != null) {
              DateTime entryDateTime =
                  dateFormatter.parse(data['date']).add(Duration(
                        hours: int.parse(entryTime.split(":")[0]),
                        minutes: int.parse(entryTime.split(":")[1]),
                      ));
              DateTime exitDateTime =
                  dateFormatter.parse(data['date']).add(Duration(
                        hours: int.parse(exitTime.split(":")[0]),
                        minutes: int.parse(exitTime.split(":")[1]),
                      ));

              Duration workedDuration = exitDateTime.difference(entryDateTime);
              totalWorkedDuration += workedDuration;
            }
          }
        });
      }

      Duration expectedMonthlyHours = await calculateExpectedMonthlyHours(
        userModel.companyId!,
        userModel.workingPattern!,
        start,
        end,
      );

      int hours = totalWorkedDuration.inHours;
      int minutes = totalWorkedDuration.inMinutes % 60;
      String formattedWorkedTime =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";

      int expectedHours = expectedMonthlyHours.inHours;
      int expectedMinutes = expectedMonthlyHours.inMinutes % 60;
      String formattedExpectedTime =
          "${expectedHours.toString().padLeft(2, '0')}:${expectedMinutes.toString().padLeft(2, '0')}";

      Duration balance = totalWorkedDuration - expectedMonthlyHours;
      int balanceHours = balance.inHours;
      int balanceMinutes = balance.inMinutes % 60;
      String formattedBalance =
          "${balanceHours.toString().padLeft(2, '0')}:${balanceMinutes.toString().padLeft(2, '0')}";

      switch (type) {
        case 'monthWorkedHours':
          this.balanceMonthHours = formattedBalance;

          break;
        case 'filterWorkedHours':
          this.balanceFilterWorkedHours = formattedWorkedTime;
          this.balanceFilterExpectedHours = formattedExpectedTime;
          this.balanceFilterHours = formattedBalance;
          break;
        default:
      }
      notifyListeners();
    } catch (e) {
      print("Error calculating total worked hours: $e");
    }
  }

  Future<Map<String, dynamic>> fetchCompanyHours(
      String companyId, String workingPattern) async {
    DocumentSnapshot<Map<String, dynamic>> companySnapshot =
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(companyId)
            .get();

    if (!companySnapshot.exists) {
      throw Exception("Company data not found for companyId: $companyId");
    }

    Map<String, dynamic>? companyData = companySnapshot.data();
    if (companyData == null || !companyData.containsKey('workingHours')) {
      throw Exception("Working hours data not found for companyId: $companyId");
    }

    Map<String, dynamic> workingHours = companyData['workingHours'];
    if (!workingHours.containsKey(workingPattern)) {
      throw Exception(
          "Working pattern '$workingPattern' not found in working hours for companyId: $companyId");
    }

    return workingHours[workingPattern] as Map<String, dynamic>;
  }

  Duration calculateExpectedDailyHours(Map<String, dynamic> daySchedule) {
    String arrivalTime = daySchedule['arrivalTime'];
    String departureTime = daySchedule['departureTime'];
    int totalBreakTime =
        int.tryParse(daySchedule['totalBreakTime'] ?? '0') ?? 0;

    DateTime arrival = DateFormat("HH:mm").parse(arrivalTime);
    DateTime departure = DateFormat("HH:mm").parse(departureTime);

    Duration workDuration = departure.difference(arrival);
    Duration breakDuration = Duration(hours: totalBreakTime);

    return workDuration - breakDuration;
  }

  int countBusinessDays(DateTime start, DateTime end) {
    int businessDays = 0;
    for (DateTime date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(Duration(days: 1))) {
      if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
        businessDays++;
      }
    }
    return businessDays;
  }

  int countSaturdays(DateTime start, DateTime end) {
    int saturdays = 0;
    for (DateTime date = start;
        date.isBefore(end) || date.isAtSameMomentAs(end);
        date = date.add(Duration(days: 1))) {
      if (date.weekday == DateTime.saturday) {
        saturdays++;
      }
    }
    return saturdays;
  }

  Future<Duration> calculateExpectedMonthlyHours(String companyId,
      String workingPattern, DateTime startDate, DateTime currentDate) async {
    Map<String, dynamic> hoursData =
        await fetchCompanyHours(companyId, workingPattern);

    Duration weekDayHours = calculateExpectedDailyHours(hoursData['weekDays']);
    Duration saturdayHours =
        calculateExpectedDailyHours(hoursData['weekEnd'] ?? {});

    int businessDays = countBusinessDays(startDate, currentDate);
    int saturdays = countSaturdays(startDate, currentDate);

    Duration totalExpectedHours =
        (weekDayHours * businessDays) + (saturdayHours * saturdays);
    return totalExpectedHours;
  }

  resetValues() {
    this.balanceFilterWorkedHours = null;
    this.balanceFilterExpectedHours = null;
    this.balanceFilterHours = null;
    notifyListeners();
  }
}
