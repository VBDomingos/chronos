import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdmModel with ChangeNotifier {
  String? _userId;
  String? _solicitationId;
  int _workingCount = 0;
  int _lateCount = 0;

  String? get uid => _userId;
  String? get solicitationId => _solicitationId;
  int? get workingCount => _workingCount;
  int? get lateCount => _lateCount;

  void setData(String? uid, String? solicitationId) {
    _userId = uid;
    _solicitationId = solicitationId;
  }

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

  Future<void> countWorkingUsers(String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> employees = await _firestore
          .collection('employees')
          .where('companyId', isEqualTo: companyId)
          .where('isWorking', isEqualTo: true)
          .get();

      _workingCount = employees.docs.length;
      notifyListeners();
    } catch (e) {
      print("Error counting working users: $e");
    }
  }

  Future<void> countLateUsers(String companyId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> employees = await _firestore
          .collection('employees')
          .where('companyId', isEqualTo: companyId)
          .where('isWorking', isEqualTo: false)
          .get();

      _lateCount = employees.docs.length;
      notifyListeners();
    } catch (e) {
      print("Error counting late users: $e");
    }
  }

  List<String> getUserNames() {
    return _companyUsers.map((user) => user['name'] as String).toList();
  }

  Future<void> confirmUserSolicitation(BuildContext context, response) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Solicitação'),
          content: Text('Tem certeza de que deseja ${response} a solicitação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await userSolicitationResponse(context, response);
    }
  }

  Future<void> userSolicitationResponse(
      BuildContext context, String response) async {
    String newStatus = response == 'aprovar' ? 'accepted' : 'rejected';

    try {
      DocumentReference solicitationDoc = FirebaseFirestore.instance
          .collection('employees')
          .doc(_userId)
          .collection('solicitations')
          .doc(_solicitationId);

      DocumentSnapshot solicitationSnapshot = await solicitationDoc.get();
      if (solicitationSnapshot.exists) {
        var solicitationData =
            solicitationSnapshot.data() as Map<String, dynamic>;
        String requestField = solicitationData['requestField'];
        String newValue = solicitationData['newValue'];

        await solicitationDoc
            .update({'status': newStatus, 'solicitationsOpen': false});

        if (response == 'aprovar') {
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(_userId)
              .collection('timeRecords')
              .where('date', isEqualTo: solicitationData['requestFieldDate'])
              .get()
              .then((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update({
                '$requestField.time': newValue,
                '$requestField.solicitationsOpen': false,
              });
            }
          });
        } else {
          await FirebaseFirestore.instance
              .collection('employees')
              .doc(_userId)
              .collection('timeRecords')
              .where('date', isEqualTo: solicitationData['requestFieldDate'])
              .get()
              .then((querySnapshot) {
            for (var doc in querySnapshot.docs) {
              doc.reference.update({
                '$requestField.solicitationsOpen': false,
              });
            }
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitação $response com sucesso!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Solicitação não encontrada.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao processar solicitação: $e')),
      );
    }

    Navigator.pop(context);
  }
}
