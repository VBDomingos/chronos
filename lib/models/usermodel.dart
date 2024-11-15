import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? _fullName;
  String? _uid;
  String? _companyId;
  String? _workingPattern;
  String? _role;

  String? get fullName => _fullName;
  String? get uid => _uid;
  String? get companyId => _companyId;
  String? get workingPattern => _workingPattern;
  String? get role => _role;

  void setUserData(String? name, String? uid, String? companyId,
      String? workingPattern, String? role) {
    _fullName = name;
    _uid = uid;
    _companyId = companyId;
    _workingPattern = workingPattern;
    _role = role;

    notifyListeners();
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    final userModel = UserModel();
    userModel.setUserData(
      map['name'] as String?,
      map['id'] as String?,
      map['companyId'] as String?,
      map['workingPattern'] as String?,
      map['role'] as String?,
    );
    return userModel;
  }
}
