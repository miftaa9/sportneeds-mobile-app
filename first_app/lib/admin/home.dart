import 'dart:convert';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => AdminHome());
  }

  @override
  State<StatefulWidget> createState() {
    return _AdminHome();
  }
}

class _AdminHome extends State<AdminHome> {
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
      _AdminHome();
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
              .from('nutrishop_produk')
              .select<List<Map<String, dynamic>>>();
          return Scaffold(
            backgroundColor: Color(0xFF2B9EA4),
            appBar: AppBar(
              title: Column(children: [
                Text(dat[0],
                    style: const TextStyle(
                      color: Color(0xFF2B9EA4),
                      fontSize: 30,
                    )),
                Text(dat[1],
                    style: const TextStyle(
                      color: Color(0xFF2B9EA4),
                    )),
              ]),
              leading: const Icon(
                Icons.account_circle,
                size: 50,
                color: Color(0xFF2B9EA4),
              ),
              backgroundColor: Colors.white, //You can make this transparent
              elevation: 0.0, //No shadow
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: Color(0xFF2B9EA4),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/first", (r) => false);
                  },
                )
              ],
              actionsIconTheme:
                  IconThemeData(color: Color(0xFF2B9EA4), size: 36),
              toolbarHeight: 80, // default is 56
            ),
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
                    final tesjpg = supabase.storage
                        .from('shop_produk')
                        .getPublicUrl(country['img']);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: /*const Icon(
                              Icons.account_circle,
                              size: 50,
                              color: Color(0xFF2B9EA4),
                            ),*/
                                Image.network(tesjpg),
                            title: RichText(
                              selectionColor: Color(0xFF2B9EA4),
                              text: TextSpan(
                                style:
                                    const TextStyle(color: Color(0xFF2B9EA4)),
                                children: [
                                  TextSpan(
                                    text: "nama toko : ${country['user_id']}\n",
                                  ),
                                  TextSpan(
                                    text: "nama produk : ${country['nama']}\n",
                                  ),
                                  TextSpan(
                                    text:
                                        "harga produk : ${country['harga']}\n",
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                              context, '/admin_edit',
                                              arguments: country)
                                          .then(onGoBack);
                                    },
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),
                          ),
                          ListTile(
                            title: RichText(
                              selectionColor: Color(0xFF2B9EA4),
                              text: TextSpan(
                                style:
                                    const TextStyle(color: Color(0xFF2B9EA4)),
                                children: [
                                  TextSpan(
                                      text: "Energi : ${country['energi']}\n"),
                                  TextSpan(
                                      text: "Water : ${country['water']}\n"),
                                  TextSpan(
                                      text:
                                          "Protein : ${country['protein']}\n"),
                                  TextSpan(text: "Fat : ${country['fat']}\n"),
                                  TextSpan(
                                      text:
                                          "Karbohidrat : ${country['karbo']}\n"),
                                  TextSpan(
                                      text:
                                          "Cholesterol : ${country['chr']}\n"),
                                  TextSpan(
                                      text: "Vitamin A : ${country['vita']}\n"),
                                  TextSpan(
                                      text: "Vitamin C : ${country['vitc']}\n"),
                                  TextSpan(
                                      text: "Vitamin E : ${country['vite']}\n"),
                                  TextSpan(
                                      text: "Magnesium : ${country['mag']}\n"),
                                  TextSpan(
                                      text: "Sodium : ${country['sod']}\n"),
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
                  }),
                );
              },
            ),
          );
        });
  }
}
