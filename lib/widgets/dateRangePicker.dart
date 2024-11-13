import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final Function(String) onDateRangeSelected;

  DateRangePicker({required this.onDateRangeSelected});

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  TextEditingController _dateController = TextEditingController();
  DateTimeRange? selectedRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime today = DateTime.now();

    DateTime tempStartDate = selectedRange?.start ?? today;
    DateTime tempEndDate = selectedRange?.end ?? today;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecione o Intervalo de Datas'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView(
              shrinkWrap: true,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: CalendarDatePicker(
                    initialDate: tempStartDate,
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: today,
                    onDateChanged: (newDate) {
                      setState(() {
                        tempStartDate = newDate;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: CalendarDatePicker(
                    initialDate: tempEndDate,
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: today,
                    onDateChanged: (newDate) {
                      setState(() {
                        tempEndDate = newDate;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedRange =
                      DateTimeRange(start: tempStartDate, end: tempEndDate);
                  final String formattedStartDate =
                      DateFormat('dd/MM/yyyy').format(tempStartDate);
                  final String formattedEndDate =
                      DateFormat('dd/MM/yyyy').format(tempEndDate);
                  _dateController.text =
                      '$formattedStartDate - $formattedEndDate';
                  widget.onDateRangeSelected(_dateController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Selecionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: Colors.blueAccent,
                  width: 2.0,
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _selectDateRange(context);
          },
        ),
      ],
    );
  }
}
