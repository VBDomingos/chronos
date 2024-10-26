import 'package:flutter/widgets.dart';

class CompanyWorkingPatternModel with ChangeNotifier {
  String? _firstEntry;
  String? _firstExit;
  String? _secondEntry;
  String? _secondExit;
  String? _journeyDuration;

  String? get firstEntry => _firstEntry;
  String? get firstExit => _firstExit;
  String? get secondEntry => _secondEntry;
  String? get secondExit => _secondExit;
  String? get journeyDuration => _journeyDuration;

  void setWorkingPattern(List<dynamic>? times) {
    print("Executando setWorkingPattern...");
    print(times);

    if (times != null && times.length >= 4) {
      _firstEntry = '${times[0].toString().padLeft(2, '0')}:00';
      _firstExit = '${times[1].toString().padLeft(2, '0')}:00';
      _secondEntry = '${times[2].toString().padLeft(2, '0')}:00';
      _secondExit = '${times[3].toString().padLeft(2, '0')}:00';
      _journeyDuration =
          '${_firstEntry} - ${_secondExit} | ${times[2] - times[1]}h';

      notifyListeners(); // Notifica ouvintes sobre a mudança
    } else {
      print("Erro: A lista de horários não possui entradas suficientes.");
    }
  }
}
