import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:project/models/companyWorkingPattern.dart';
import 'package:provider/provider.dart';

class UserModel with ChangeNotifier {
  String? _fullName;

  String? get fullName => _fullName;

  void setUserData(String? name) {
    print(name);
    _fullName = name;
    notifyListeners();
  }

  /*Future<void> setCompanyWorkingTime(BuildContext context) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> companyWorkingTimeData =
          await FirebaseFirestore.instance
              .collection('company_working_pattern')
              .doc(_companyId)
              .get();

      print(companyWorkingTimeData.data()?['cedo']);
      print(_workingPattern);

      if (companyWorkingTimeData.exists) {
        switch (_workingPattern) {
          case "cedo":
            Provider.of<CompanyWorkingPatternModel>(context, listen: false)
                .setWorkingPattern(companyWorkingTimeData.data()?['cedo']);
            break;
          case "halftime":
            Provider.of<CompanyWorkingPatternModel>(context, listen: false)
                .setWorkingPattern(companyWorkingTimeData.data()?['halftime']);
            break;
          case "free":
            Provider.of<CompanyWorkingPatternModel>(context, listen: false)
                .setWorkingPattern(companyWorkingTimeData.data()?['fulltime']);
            break;
          default:
        }
      }
    } catch (e) {
      print('Erro ao buscar dados da empresa: $e');
    }
  }*/
}
