import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class adminAktifitas extends StatefulWidget {
  const adminAktifitas({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => adminAktifitas());
  }

  @override
  State<StatefulWidget> createState() {
    return _adminAktifitas();
  }
}

class _adminAktifitas extends State<adminAktifitas> {
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

  deleteData(id) async {
    await Supabase.instance.client
        .from('cabang_olahraga_aktifitas')
        .delete()
        .match({'id': id});
  }

  onGoBack(dynamic value) {
    setState(() {
      _adminAktifitas();
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
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final namacabora = arg["nama"];
    final cabora_id = arg['id'];
    return FutureBuilder<List>(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;

          final _future = supabase
              .from('cabang_olahraga_aktifitas')
              .select<List<Map<String, dynamic>>>()
              .eq('cabora_id', cabora_id);
          return Scaffold(
              backgroundColor: Color(0xFF2B9EA4),
              appBar: AppBar(
                title: Text('Aktifitas untuk ${namacabora}',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF2B9EA4),
                    )),
                backgroundColor: Colors.white,
                elevation: 0.0,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Color(0xFF2B9EA4),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/admin_aktifitas_cu',
                        arguments: {
                          'cabora_id': cabora_id,
                        },
                      ).then(onGoBack);
                    },
                  )
                ],
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
              body: Column(children: <Widget>[
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final countries = snapshot.data!;
                      print(countries);
                      return ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: ((context, index) {
                          final country = countries[index];
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
                                          text: country['nama'],
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
                                                context, '/admin_aktifitas_cu',
                                                arguments: {
                                                  'ubah': country
                                                }).then(onGoBack);
                                          },
                                          icon: const Icon(Icons.edit,
                                              color: Color(0xFF2B9EA4))),
                                      IconButton(
                                          onPressed: () {
                                            showAlertDialog(
                                                context, country['id']);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Color(0xFF2B9EA4),
                                          )),
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
        });
  }
}
