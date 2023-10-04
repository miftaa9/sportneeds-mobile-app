
import 'dart:convert';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:first_app/main.dart';

import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('Today\'s Event 1'),
      Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class custtKalender extends StatefulWidget {
  @override
  _custtKalenderState createState() => _custtKalenderState();
}

class _custtKalenderState extends State<custtKalender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  var ab = [
    'Energy',
    'Water',
    'Protein',
    'Fat',
    'Carbohydr',
    'Dietary',
    'Alcohol',
    'PUFA',
    'Cholesterol',
    'Vit. A',
    'Carotene',
    'Vit. E',
    'Vit. B1',
    'Vit. B2',
    'Vit. B6',
    'Tot. Fol.Acid',
    'Vit. C',
    'Sodium',
    'Potassium',
    'Calcium',
    'Magnesium',
    'Phosphorus',
    'Iron',
    'Zinc',
  ];


  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final int uid = arg["uid"];

    String dateO = DateFormat("yyyy-MM-dd").format(_selectedDay);
    var a = supabase.from("cabang_olahraga").select().eq('id',uid);
    return Scaffold(
        appBar: const LayoutCustomerAppBar(
            title: Text('Kalender Gizi',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2B9EA4),
                ))),
      body: Column(
        children: [
TableCalendar(
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            // Call `setState()` when updating the selected day
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            // Call `setState()` when updating calendar format
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          // No need to call `setState()` here
          _focusedDay = focusedDay;
        },
      ),
      Expanded(child: FutureBuilder(
        future: a,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final zz2 = snapshot.data!;

          var cvv = supabase.from("cust_gizi").select().eq('uid',uid);

          return ListView.builder(
                  itemCount: 24,
                  itemBuilder: ((context, index) {
                    
                    var namaa = ab[index];
                    var nama = "a${(index+1).toString()}";
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: RichText(
                              selectionColor: Color(0xFF2B9EA4),
                              text: TextSpan(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Color(0xFF2B9EA4)),
                                children: [
                                  TextSpan(
                                    text: namaa,
                                  ),
                                ],
                              ),
                            ),
                              trailing: Text(
                                zz2[0][nama],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B9EA4),
                                ),
                              ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  })
                  );
        }
)
      )

        ],
      )
      
    );
  }
}