import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:needlinc/needlinc/needlinc-variables/colors.dart';
import '../backend/user-account/functionality.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<DateTime?> _selectedDates = [DateTime.now()];
  List<DateTime?>? selectADate;
  bool showCalendar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            showCalendar ? _buildDatePickerWidget() : _buildSelectDateButton(),
      ),
    );
  }

  void _handleDateSelection(List<DateTime?> selectedDates) {
    setState(() {
      selectADate = _selectedDates;
      _selectedDates = selectedDates;
      showCalendar = false; // Hide the calendar after a date is selected
    });
  }

  Widget _buildSelectDateButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showCalendar = true;
        });
      },
      child: selectADate == null
          ? Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: NeedlincColors.black1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Text(
                "Select your date of birth",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: NeedlincColors.black1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                _buildSelectedDates(),
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
    );
  }

  Widget _buildDatePickerWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the border radius as needed
      ),
      elevation: 4.0, // Add elevation for a shadow effect
      child: Column(
        children: [
          CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            value: _selectedDates,
            onValueChanged: _handleDateSelection,
          ),
        ],
      ),
    );
  }

  String _buildSelectedDates() {
    final dateOfBirth = _selectedDates
        .map((date) => date?.toString().substring(0, 10) ?? 'null')
        .join(', ');
    getDateOfBirth(birthDay: dateOfBirth);
    return dateOfBirth;
  }
}
