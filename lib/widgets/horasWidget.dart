import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/views/correcao_ponto.dart';

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
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      await _fetchTimeRecords();
    } else {
      print("Usuário não está autenticado.");
    }
  }

  Future<void> _fetchTimeRecords() async {
    if (userId == null) return;

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
              'date': doc['date'],
              'entries': <Map<String, String>>[],
            };

            doc.data().forEach((key, value) {
              if (key.startsWith('entrada-')) {
                String entryNumber = key.split('-')[1];
                String entryTime = value.toString();
                String? exitTime = doc.data()['saida-$entryNumber']?.toString();

                record['entries'].add({
                  'entrada': entryTime,
                  'entrada_key': key,
                  if (exitTime != null && exitTime != '---') 'saida': exitTime,
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
      required String originalKey}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CorrecaoPontoScreen(
          tipo: tipo,
          date: date,
          hora: hora,
          originalKey: originalKey,
        ),
      ),
    );
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

  Widget _buildDiaTile(String date, List<Map<String, String>> entries) {
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
                  entry['entrada']!, "Entrada", date, entry['entrada_key']!),
              if (entry.containsKey('saida'))
                _buildHoraRow(
                    entry['saida']!, "Saída", date, entry['entrada_key']!),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHoraRow(
      String hora, String tipo, String date, String originalKey) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: ListTile(
        leading: Icon(
          tipo == "Entrada" ? Icons.circle : Icons.circle,
          color: tipo == "Entrada" ? Colors.green : Colors.red,
        ),
        title: Text("$hora - $tipo"),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            _navigateToCorrecaoPontoScreen(context,
                tipo: tipo, date: date, hora: hora, originalKey: originalKey);
          },
        ),
      ),
    );
  }
}
