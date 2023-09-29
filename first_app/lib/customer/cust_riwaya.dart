import 'dart:developer';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import '../utils/date.dart' as date_util;
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:first_app/main.dart';

class MyHomePage extends StatefulWidget {
  // ------------------------------- CONSTRUCTORS ------------------------------
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  // --------------------------------- METHODS ---------------------------------
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedValue = DateTime.now();
  List<DateTime> currentMonthList = List.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final uid = arg["uid"];
    currentMonthList = date_util.DateUtils.daysInMonth(_selectedValue);
    currentMonthList.sort((a, b) => a.day.compareTo(b.day));
    currentMonthList = currentMonthList.toSet().toList();
    String dateO = DateFormat("yyyy-MM-dd").format(_selectedValue);
    print("dd $dateO");

    final _future = supabase
        .from('transaction')
        .select()
        .eq('iduser', uid)
        .eq('status', 'selesai')
        .like('datez', '%$dateO%')
        .order('created_at', ascending: true);
    ;

    final _futurex2 = supabase
        .from('kalori')
        .select()
        .eq('user_id', uid)
        .eq('tgl', dateO)
        .order('id', ascending: true);
    ;
    return Scaffold(
        backgroundColor: Color(0xFF2B9EA4),
        appBar: const LayoutCustomerAppBar(
            title: Text('Kalender Riwayat',
                style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        bottomNavigationBar: LayoutCustomerBottomNav(),
        body: Column(children: <Widget>[
          Container(
              height: 170,
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
          Container(
            height: 100,
            child: FutureBuilder(
                future: _futurex2,
                builder: (context, snapshot) {
                  if (snapshot.data.length == 0) {
                    return Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.greenAccent,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: ListTile(
                              title: Text(
                                'Kalori Harian',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B9EA4),
                                ),
                              ),
                              trailing: Text(
                                '0  kkal',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B9EA4),
                                ),
                              ),
                            )));
                  }
                  log("ggg ${snapshot.data}");
                  final yat = snapshot.data!;
                  double totalenergiz = 0.0;
                  int no = 0;
                  log("vv $yat");
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: yat.length,
                      itemBuilder: (context, index) {
                        final yatz = yat[index];
                        totalenergiz += double.parse(yatz['energi']);
                        no += 1;
                        log("km $no $index ${yat.length}");
                        return (index == (yat.length - 1))
                            ? Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.greenAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      20.0), //<-- SEE HERE
                                ),
                                child: Padding(
                                    padding: EdgeInsets.all(2.0),
                                    child: ListTile(
                                      title: Text(
                                        'Kalori Harian',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2B9EA4),
                                        ),
                                      ),
                                      trailing: Text(
                                        '${totalenergiz.toStringAsFixed(2)}  kkal',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2B9EA4),
                                        ),
                                      ),
                                    )))
                            : Text('');
                      });
                }),
          ),
          Expanded(
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
                    final data1 = supabase
                        .from('user_nutrishop')
                        .select('id, namatoko')
                        .eq('id', country['sid']);
                    log("${country}");

                    var parts = country['created_at'].split('T');
                    var prefix = parts[0].trim();
                    var dateee = parts.sublist(1).join(':').trim();
                    dateee = dateee.split('.');
                    dateee = dateee[0].trim();
                    log("ww $dateee");
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
                                    text: "Pesanan ${index + 1} \n$dateee",
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text("${country['status']} "),
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    //terimaProcess(mid,message.idcart);
                                    Navigator.pushNamed(
                                      context,
                                      '/customer_riwayat_detail',
                                      arguments: {
                                        'tid': country['id'],
                                        'idcart': country['idcart'],
                                        'status': country['status'],
                                      },
                                    );
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Lihat',
                                      style: TextStyle(
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
        ]));
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
