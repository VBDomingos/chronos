import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/models/adm_model.dart';
import 'package:project/models/userPoint.dart';
import 'package:project/models/usermodel.dart';
import 'package:project/views/correcao_ponto.dart';
import 'package:project/widgets/mapDialog.dart';
import 'package:provider/provider.dart';

class HorasWidget extends StatefulWidget {
  final String dataInicial;
  final String dataFinal;

  HorasWidget({
    required this.dataInicial,
    required this.dataFinal,
  });

  @override
  _HorasWidgetState createState() => _HorasWidgetState();
}

class _HorasWidgetState extends State<HorasWidget> {
  List<Map<String, dynamic>> timeRecords = [];
  String? userId;
  var userFilter;

  @override
  void initState() {
    super.initState();
    _initializeUserIdAndFetchRecords();
  }

  @override
  void didUpdateWidget(covariant HorasWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dataInicial != widget.dataInicial ||
        oldWidget.dataFinal != widget.dataFinal) {
      _fetchTimeRecords();
    }
  }

  Future<void> _initializeUserIdAndFetchRecords() async {
    final userPointModel = Provider.of<UserPointModel>(context, listen: false);
    final userFilter = userPointModel.userFilter;

    String? userId;
    if (userFilter != null) {
      userId = userFilter.uid;
    } else {
      final User? firebaseUser = FirebaseAuth.instance.currentUser;
      userId = firebaseUser?.uid;
    }

    if (userId != null) {
      setState(() {
        this.userId = userId;
      });
      await _fetchTimeRecords();
    } else {
      print("Nenhum usuário definido ou autenticado.");
    }
  }

  Future<void> _fetchTimeRecords() async {
    if (userId == null ||
        widget.dataFinal.isEmpty ||
        widget.dataInicial.isEmpty) return;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('employees')
          .doc(userId)
          .collection('timeRecords')
          .where('date', isGreaterThanOrEqualTo: widget.dataInicial)
          .where('date', isLessThanOrEqualTo: widget.dataFinal)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          timeRecords = snapshot.docs.map((doc) {
            Map<String, dynamic> record = {
              'id': doc.id,
              'date': doc['date'] ?? '',
              'entries': <Map<String, dynamic>>[],
            };

            doc.data().forEach((key, value) {
              if (key.startsWith('entrada-') && value is Map<String, dynamic>) {
                String entryTime = value['time']?.toString() ?? '---';
                bool entrySolicitationsOpen =
                    value['solicitationsOpen'] ?? false;
                double latitudeEntrada = (value['latitude'] ?? 0.0).toDouble();
                double longitudeEntrada =
                    (value['longitude'] ?? 0.0).toDouble();

                record['entries'].add({
                  'tipo': 'Entrada',
                  'time': entryTime,
                  'solicitationsOpen': entrySolicitationsOpen,
                  'latitude': latitudeEntrada,
                  'longitude': longitudeEntrada,
                  'originalKey': key,
                });
              } else if (key.startsWith('saida-') &&
                  value is Map<String, dynamic>) {
                String exitTime = value['time']?.toString() ?? '---';
                bool exitSolicitationsOpen =
                    value['solicitationsOpen'] ?? false;
                double latitudeSaida = (value['latitude'] ?? 0.0).toDouble();
                double longitudeSaida = (value['longitude'] ?? 0.0).toDouble();

                record['entries'].add({
                  'tipo': 'Saida',
                  'time': exitTime,
                  'solicitationsOpen': exitSolicitationsOpen,
                  'latitude': latitudeSaida,
                  'longitude': longitudeSaida,
                  'originalKey': key,
                });
              }
            });

            return record;
          }).toList();
        });
      } else {
        print(
            "Nenhum registro encontrado para o intervalo ${widget.dataInicial} - ${widget.dataFinal}.");
      }
    } catch (e) {
      print("Erro ao buscar registros de horas: $e");
    }
  }

  void _navigateToCorrecaoPontoScreen(BuildContext context,
      {required String tipo,
      required String date,
      required String hora,
      required String originalKey,
      required String reason,
      required String newValue}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CorrecaoPontoScreen(
          tipo: tipo,
          date: date,
          hora: hora,
          originalKey: originalKey,
          reason: reason,
          newValue: newValue,
        ),
      ),
    );
  }

  void _viewSolicitation(BuildContext context, String originalKey, String date,
      String type) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('employees')
          .doc(userId)
          .collection('solicitations')
          .where('requestField', isEqualTo: originalKey)
          .where('requestFieldDate', isEqualTo: date)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final admModel = Provider.of<AdmModel>(context, listen: false);

        admModel.setData(userId, snapshot.docs.first.id);

        _navigateToCorrecaoPontoScreen(
          context,
          tipo: type,
          date: snapshot.docs.first['requestFieldDate'],
          hora: snapshot.docs.first['previousValue'],
          originalKey: snapshot.docs.first['requestField'],
          reason: snapshot.docs.first['reason'],
          newValue: snapshot.docs.first['newValue'],
        );
      } else {
        print("Nenhuma solicitação encontrada para o campo $originalKey.");
      }
    } catch (e) {
      print("Erro ao buscar solicitação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: timeRecords.isNotEmpty
            ? timeRecords.map((record) {
                return _buildDiaTile(
                  record['date'],
                  record['entries'] ?? [],
                );
              }).toList()
            : [
                const Text(
                    "Nenhum registro encontrado para o intervalo especificado.")
              ],
      ),
    );
  }

  Widget _buildDiaTile(String date, List<Map<String, dynamic>> entries) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ExpansionTile(
        title: Text(date),
        children: entries.map((entry) {
          return Column(
            children: [
              _buildHoraRow(
                entry['time'] ?? '---',
                entry['tipo'] ?? 'Unknown',
                date,
                entry['solicitationsOpen'] ?? false,
                entry['latitude'] ?? 0.0,
                entry['longitude'] ?? 0.0,
                entry['originalKey'],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHoraRow(
    String hora,
    String tipo,
    String date,
    bool solicitationsOpen,
    double latitude,
    double longitude,
    String originalKey,
  ) {
    final userModel = Provider.of<UserModel>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: ListTile(
        leading: Icon(
          tipo == "Entrada" ? Icons.circle : Icons.circle,
          color: solicitationsOpen
              ? Colors.yellow
              : (tipo == "Entrada" ? Colors.green : Colors.red),
        ),
        title: Text("$hora - $tipo"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (solicitationsOpen && userModel.role == 'admin')
              IconButton(
                icon: Icon(Icons.info),
                onPressed: () {
                  _viewSolicitation(context, originalKey, date, tipo);
                },
              ),
            if (!solicitationsOpen && userModel.role != 'admin')
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _navigateToCorrecaoPontoScreen(
                    context,
                    tipo: tipo,
                    date: date,
                    hora: hora,
                    originalKey: originalKey,
                    reason: '',
                    newValue: '',
                  );
                },
              ),
            if (!solicitationsOpen && userModel.role == 'admin')
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    if (latitude == 0.0 && longitude == 0.0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Localização não disponível.')),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MapDialog(
                            latitude: latitude,
                            longitude: longitude,
                          );
                        },
                      );
                    }
                  },
                  child: Icon(
                    Icons.map,
                    color: Colors.blue,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
