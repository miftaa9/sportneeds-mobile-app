import 'dart:convert';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class CustNutrisi extends StatefulWidget {
  const CustNutrisi({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => CustNutrisi());
  }

  @override
  State<StatefulWidget> createState() {
    return _CustNutrisi();
  }
}

class _CustNutrisi extends State<CustNutrisi> {
  int _selectedIndex = 0;

  showAlertDialog(BuildContext context, int id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yakin"),
      onPressed: () {
        deleteData(id);
        onGoBack(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Yakin Hapus?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  tes() {
    log("dewa");
  }

  deleteData(id) async {
    await supabase.from('nutrishop_produk').delete().match({'id': id});
  }

  onGoBack(dynamic value) {
    tes();
    setState(() {
      _CustNutrisi();
    });
  }

  Future<List> getUserNamePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('usernama') ?? 'K',
      prefs.getString('email') ?? 'K',
      prefs.getBool('active') ?? false,
      prefs.getInt('userid') ?? 0
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;

          final _future = supabase
              .from('transaction')
              .select<List<Map<String, dynamic>>>()
              .eq('iduser', dat[3]);
          return Scaffold(
            backgroundColor: Color(0xFF2B9EA4),
            appBar: const LayoutCustomerAppBar(
                title: Text('Nutrisi Harian',
                    style: TextStyle(
                      fontSize: 34,
                      color: Color(0xFF2B9EA4),
                    ))),
            body: FutureBuilder<List<Map<String, dynamic>>>(
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
                    log("$country");
                    final future2 = supabase
                        .from('cart')
                        .select<List<Map<String, dynamic>>>(
                            'id, jumlah, status, nutrishop_produk(id, nama,harga,img, energi)')
                        .in_('id', country['idcart']);
                    return FutureBuilder<List<Map<String, dynamic>>>(
                        future: future2,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          final countries2 = snapshot.data!;
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: countries2.length,
                              itemBuilder: ((context, index) {
                                final country = countries2[index];
                                log("$country");
                                final produk = country['nutrishop_produk'];
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
                                                color: Color(0xFF2B9EA4)),
                                            children: [
                                              TextSpan(
                                                  text:
                                                      "Energi : ${produk['energi']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Water : ${country['water']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Protein : ${country['protein']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Fat : ${country['fat']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Karbohidrat : ${country['karbo']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Cholesterol : ${country['chr']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Vitamin A : ${country['vita']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Vitamin C : ${country['vitc']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Vitamin E : ${country['vite']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Magnesium : ${country['mag']}\n"),
                                              TextSpan(
                                                  text:
                                                      "Sodium : ${country['sod']}\n"),
                                            ],
                                          ),
                                        ),
                                        onTap: () {},
                                      ),
                                      Column(children: [
                                        const SizedBox(height: 20),
                                      ]),
                                    ],
                                  ),
                                );
                              }));
                        });
                  }),
                );
              },
            ),
          );
        });
  }
}
