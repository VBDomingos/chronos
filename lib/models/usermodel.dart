import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:project/models/companyWorkingPattern.dart';
import 'package:provider/provider.dart';

class UserModel with ChangeNotifier {
  String? _fullName;
  String? _uid;
  String? _companyId;
  String? _workingPattern;

  String? get fullName => _fullName;
  String? get uid => _uid;
  String? get companyId => _companyId;
  String? get workingPattern => _workingPattern;

  void setUserData(
      String? name, String? uid, String? companyId, String? workingPattern) {
    _fullName = name;
    _uid = uid;
    _companyId = companyId;
    _workingPattern = workingPattern;

    notifyListeners();
  }
}
