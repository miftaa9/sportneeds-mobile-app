import 'dart:developer';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../utils/date.dart' as date_util;
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:first_app/main.dart';

class shopPendapatan extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const shopPendapatan({
    Key? key,
  }) : super(key: key);

  // --------------------------------- METHODS ---------------------------------
  @override
  State<shopPendapatan> createState() => _shopPendapatan();
}

class _shopPendapatan extends State<shopPendapatan> {
  DateTime _selectedValue = DateTime.now();
  List<DateTime> currentMonthList = List.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentMonthList = date_util.DateUtils.daysInMonth(_selectedValue);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    String dateO = DateFormat("yyyy-MM-dd").format(_selectedValue);
    print("dd $dateO");
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final sid = arg["sid"];
    var totalz = 0;

    final _future = supabase
        .from('transaction')
        .select()
        .eq('status', 'selesai')
        .eq('sid', sid)
        .like('datez', '%$dateO%');
    return Scaffold(
      backgroundColor: Color(0xFF2B9EA4),
      appBar: const LayoutCustomerAppBar(
          title: Text('Pendapatan',
              style: TextStyle(
                fontSize: 34,
                color: Color(0xFF2B9EA4),
              ))),
      body: Column(children: <Widget>[
        Expanded(
            flex: 3,
            child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.greenAccent,
                  ),
                  borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                ),
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                          child: Text(
                              DateFormat().add_yM().format(_selectedValue!)),
                          onPressed: () => _onPressed(context: context),
                        ),
                        dtpck(_selectedValue),
                        Text("$_selectedValue")
                      ],
                    )))),
        Expanded(
          flex: 9,
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final countries = snapshot.data!;
              return ListView.builder(
                itemCount: countries.length,
                itemBuilder: ((context, index) {
                  final country = countries[index];
                  totalz = totalz + int.parse(country['total']);
                  final data1 = supabase
                      .from('user_nutrishop')
                      .select('id, namatoko')
                      .eq('id', country['sid']);
                  log("${country}");
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
                                  color: Color(0xFF2B9EA4)),
                              children: [
                                TextSpan(
                                  text: "${country['created_at']}",
                                ),
                              ],
                            ),
                          ),
                          subtitle: Text("${country['status']}"),
                          onTap: () {},
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    '${country['total']}',
                                    style: const TextStyle(
                                        color: Color(0xFF2B9EA4),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        )
      ]),
      bottomNavigationBar: BottomAppBar(
          child: Container(
              height: 70,
              child: FutureBuilder(
                  future: _future,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final countries = snapshot.data!;
                    var ztot = 0;
                    return ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: ((context, index) {
                          final country = countries[index];
                          ztot += int.parse(country['total']);
                          if (index == (countries.length - 1)) {
                            return Column(
                              children: <Widget>[
                                Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text("Total Pemasukan",
                                            style: TextStyle(
                                              color: Color(0xFF2B9EA4),
                                              fontSize: 30,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text("$ztot",
                                            style: TextStyle(
                                              color: Color(0xFF2B9EA4),
                                              fontSize: 30,
                                            )),
                                      )
                                    ]),
                              ],
                            );
                          }
                        }));
                  }))),
    );
  }

  Widget dtpck(selectedValue) {
    return DatePicker(
      currentMonthList[0],
      initialSelectedDate: selectedValue,
      selectionColor: Color(0xFF2B9EA4),
      selectedTextColor: Colors.white,
      daysCount: currentMonthList.length,
      onDateChange: (date) {
        // New date selected
        setState(() {
          _selectedValue = date;
        });
      },
    );
  }

  Future<void> _onPressed({
    required BuildContext context,
    String? locale,
  }) async {
    final localeObj = locale != null ? Locale(locale) : null;
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: _selectedValue ?? DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2030),
      locale: localeObj,
    );
    // final selected = await showDatePicker(
    //   context: context,
    //   initialDate: _selected ?? DateTime.now(),
    //   firstDate: DateTime(2019),
    //   lastDate: DateTime(2022),
    //   locale: localeObj,
    // );
    if (selected != null) {
      setState(() {
        _selectedValue = selected;
      });
    }
  }
}
