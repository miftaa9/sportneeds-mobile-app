import 'dart:convert';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class AdminGiziShop extends StatefulWidget {
  const AdminGiziShop({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => AdminGiziShop());
  }

  @override
  State<StatefulWidget> createState() {
    return _AdminGiziShop();
  }
}

class _AdminGiziShop extends State<AdminGiziShop> {
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
      _AdminGiziShop();
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
              title: Text("Data Cabang Olahraga",
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF2B9EA4),
                  )),
              backgroundColor: Colors.white,
              elevation: 0.0, //No shadow
              /*actions: [
          Icon(Icons.keyboard_arrow_down),
        ],*/

              actionsIconTheme:
                  IconThemeData(color: Color(0xFF2B9EA4), size: 36),
              toolbarHeight: 80, // default is 56
              leading: Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(2)),
                    backgroundColor: MaterialStateProperty.all(
                        Color(0xFF2B9EA4)), // <-- Button color
                    overlayColor:
                        MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed))
                        return Color.fromARGB(
                            255, 34, 125, 129); // <-- Splash color
                    }),
                  ),
                ),
              ),
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
                    print(country);
                    //var jso = json.decode(country['jsonn']);

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
                                              context, '/admin_gizishop_cu',
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
                                  for (var i = 0; i < 24; i++) ...[
                                    TextSpan(
                                        text:
                                            "${ab[i]} : ${country['a' + i.toString()]}\n"),
                                  ],
                                ],
                              ),
                            ),
                            /*
                              trailing: Text(
                                "${country['a' + i.toString()]}\n",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2B9EA4),
                                ),
                              ),*/
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
