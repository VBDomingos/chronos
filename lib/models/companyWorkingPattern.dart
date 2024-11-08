import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompanyWorkingPatternModel with ChangeNotifier {
  Object? _userWorkingPattern;

  Object? get userWorkingPattern => _userWorkingPattern;
  String? get breakReturn => _userWorkingPattern != null
      ? incrementHour((_userWorkingPattern as Map<String, dynamic>)['break'])
      : null;
  String? get journeyDuration => _userWorkingPattern != null
      ? setJourneyDuration(
          (_userWorkingPattern as Map<String, dynamic>)['arrivalTime'],
          (_userWorkingPattern as Map<String, dynamic>)['departureTime'],
          (_userWorkingPattern as Map<String, dynamic>)['totalBreakTime'])
      : null;
  final now = DateTime.now();

  Future<void> setWorkingPattern(
      String companyId, String workingPattern) async {
    DocumentSnapshot<Map<String, dynamic>> companyDoc = await FirebaseFirestore
        .instance
        .collection('companies')
        .doc(companyId)
        .get();

    if (companyDoc.exists) {
      final data = companyDoc.data()?['workingHours'];

      if (data != null) {
        switch (workingPattern) {
          case 'clt':
            now.weekday == 6 || now.weekday == 7
                ? _userWorkingPattern = data['clt']['weekEnd']
                : _userWorkingPattern = data['clt']['weekDays'];
            break;
          case 'estagio':
            now.weekday == 6 || now.weekday == 7
                ? _userWorkingPattern = data['estagio']['weekEnd']
                : _userWorkingPattern = data['estagio']['weekDays'];
            break;
          default:
            _userWorkingPattern = null;
        }
      }
    }
    notifyListeners();
  }

  String incrementHour(String timeString) {
    // Converte a string de hora para DateTime
    DateTime time = DateFormat('HH:mm').parse(timeString);

    // Adiciona uma hora
    DateTime incrementedTime = time.add(const Duration(hours: 1));

    // Converte de volta para string no formato HH:mm
    return DateFormat('HH:mm').format(incrementedTime);
  }

  String setJourneyDuration(String entry, String exit, String breakTime) {
    return '$entry - $exit | ${breakTime}h';
  }
}
