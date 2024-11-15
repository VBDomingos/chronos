import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdmModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _companyUsers = [];

  List<Map<String, dynamic>> get companyUsers => _companyUsers;

  Future<void> fetchUsersByCompanyId(String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> userQuery = await _firestore
          .collection('employees')
          .where('companyId', isEqualTo: companyId)
          .get();

      _companyUsers = userQuery.docs.map((doc) {
        final userData = doc.data();
        userData['id'] = doc.id;
        return userData;
      }).toList();

      notifyListeners();
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<int> countWorkingUsers(String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> employees = await _firestore
          .collection('employees')
          .where('companyId', isEqualTo: companyId)
          .where('isWorking', isEqualTo: true)
          .get();

      return employees.docs.length;
    } catch (e) {
      print("Error counting working users: $e");
      return 0;
    }
  }

  Future<int> countLateUsers(String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> employees = await _firestore
          .collection('employees')
          .where('companyId', isEqualTo: companyId)
          .where('isWorking', isEqualTo: false)
          .get();

      return employees.docs.length;
    } catch (e) {
      print("Error counting late users: $e");
      return 0;
    }
  }

  List<String> getUserNames() {
    return _companyUsers.map((user) => user['name'] as String).toList();
  }
}
