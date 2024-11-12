import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/userPoint.dart';
import 'package:provider/provider.dart';
import 'package:project/views/history.dart';
import 'package:project/views/tela_company.dart';
import 'package:project/widgets/bottom_nav_bar.dart';
import 'package:project/widgets/header.dart';

class CorrecaoPontoScreen extends StatefulWidget {
  final String tipo;
  final String date;
  final String hora;
  final String originalKey;

  const CorrecaoPontoScreen({
    Key? key,
    required this.tipo,
    required this.date,
    required this.hora,
    required this.originalKey,
  }) : super(key: key);

  @override
  _CorrecaoPontoScreenState createState() => _CorrecaoPontoScreenState();
}

class _CorrecaoPontoScreenState extends State<CorrecaoPontoScreen> {
  String _tipoCorrecao = 'entrada';
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoCorrecao = widget.tipo.toLowerCase();
    _dateController.text = widget.date;
    _timeController.text = widget.hora;
  }

  Future<void> _selectDate(BuildContext context) async {
    // Converte o texto do controlador em um objeto DateTime ou usa DateTime.now() como padrão.
    DateTime initialDate;
    if (_dateController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd/MM/yyyy').parse(_dateController.text);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    // Converte o texto do controlador em um objeto TimeOfDay ou usa TimeOfDay.now() como padrão.
    TimeOfDay initialTime;
    if (_timeController.text.isNotEmpty) {
      final timeParts = _timeController.text.split(":");
      if (timeParts.length == 2) {
        initialTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      } else {
        initialTime = TimeOfDay.now();
      }
    } else {
      initialTime = TimeOfDay.now();
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        _timeController.text = _selectedTime?.format(context) ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPoint = Provider.of<UserPointModel>(context);
    return Scaffold(
      appBar: Header(),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipoCorrecao = 'entrada';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tipoCorrecao == 'entrada'
                            ? Colors.green
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(
                        'Entrada',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _tipoCorrecao == 'entrada'
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipoCorrecao = 'saida';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _tipoCorrecao == 'saida'
                            ? Colors.red
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Text(
                        'Saída',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _tipoCorrecao == 'saida'
                              ? Colors.white
                              : Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Data',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Horário',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _selectTime(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24.0),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: 'Justificativa*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: 3,
              maxLength: 150,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await userPoint.confirmAndRequestChangeWorkingTime(
                    context,
                    _reasonController,
                    _timeController,
                    widget.hora,
                    widget.originalKey);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color.fromARGB(255, 205, 233, 255),
              ),
              child: Text('SOLICITAR CORREÇÃO'),
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color.fromARGB(255, 255, 205, 205),
              ),
              child: Text('CANCELAR', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
