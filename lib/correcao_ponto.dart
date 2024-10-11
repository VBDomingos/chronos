import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/main.dart';
import 'package:project/tela_company.dart';
import 'package:project/widgets/bottom_nav_bar.dart';
import 'package:project/widgets/header.dart';

class CorrecaoPontoScreen extends StatefulWidget {
  @override
  _CorrecaoPontoScreenState createState() => _CorrecaoPontoScreenState();
}

class _CorrecaoPontoScreenState extends State<CorrecaoPontoScreen> {
  String _tipoCorrecao = 'entrada'; // 'entrada' ou 'saida'
  TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;
  TextEditingController _timeController = TextEditingController();
  TimeOfDay? _selectedTime;

  // Função para abrir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        // Formatando a hora selecionada no formato "HH:mm"
        _timeController.text = _selectedTime!.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      // Garante que a tela se ajuste quando o teclado estiver aberto
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Opções de Entrada/Saída com cores
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
                      padding: EdgeInsets.symmetric(vertical: 12),
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
                SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _tipoCorrecao = 'saida';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
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

            // Campo de Data
            TextField(
              controller: _dateController, // Controlador do campo de texto
              decoration: InputDecoration(
                labelText: 'Data',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    // Abre o seletor de data
                    _selectDate(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              readOnly: true, // O usuário não pode digitar diretamente
            ),
            const SizedBox(height: 24.0),

            // Campo de Hora
            TextField(
              controller: _timeController, // Controlador do campo de texto
              decoration: InputDecoration(
                labelText: 'Horário',
                suffixIcon: IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () {
                    // Abre o seletor de horário
                    _selectTime(context);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              readOnly: true, // O usuário não pode digitar diretamente
            ),
            const SizedBox(height: 24.0),

            // Campo de Justificativa (obrigatório)
            TextField(
              decoration: InputDecoration(
                labelText: 'Justificativa*',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              maxLines: 3,
              maxLength: 50,
            ),
            const SizedBox(height: 16.0),

            // Botões de Ação
            ElevatedButton(
              onPressed: () {
                // Ação para solicitar correção
              },
              child: Text('SOLICITAR CORREÇÃO'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                backgroundColor: const Color.fromARGB(255, 205, 233, 255),
              ),
            ),
            const SizedBox(height: 16.0),

            OutlinedButton(
              onPressed: () {
                // Ação para cancelar
                Navigator.pop(context);
              },
              child: Text('CANCELAR'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
              ),
            ),
          ],
        ),
      ),
      // Rodapé
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
