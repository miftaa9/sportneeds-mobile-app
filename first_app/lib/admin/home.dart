import 'package:first_app/layout/customerBottomNav.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  _adminHome createState() => _adminHome();
}

class _adminHome extends State<adminHome> {
  //String nama = '';
  @override
  void initState() {
    super.initState();
  }

/*
  Future<String> dat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nama = prefs.getString('usernama')!;
    return nama;
  }*/
  Future<List> getUserNamePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('usernama') ?? 'K',
      prefs.getString('email') ?? 'K',
      prefs.getBool('active') ?? false,
      prefs.getInt('userid') ?? 0,
      prefs.getString('pic') ?? ''
    ];
  }

  onGoBack(dynamic value) {
    setState(() {
      _adminHome();
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, "/first", (r) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout ?"),
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

  @override
  Widget build(BuildContext context) {
    log("$context");
    return FutureBuilder<List>(
      future: getUserNamePref(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final dat = snapshot.data!;
        final tesjpg =
            supabase.storage.from('shop_produk').getPublicUrl(dat[4]);
        return Scaffold(
          backgroundColor: Color(0xFF2B9EA4),
          appBar: AppBar(
            title: Column(children: [
              Text(dat[0],
                  style: TextStyle(
                    color: Color(0xFF2B9EA4),
                    fontSize: 30,
                  )),
              Text(dat[1],
                  style: TextStyle(
                    color: Color(0xFF2B9EA4),
                  )),
            ]),
            leading: IconButton(
              icon: (dat[4] == '')
                  ? const Icon(
                      Icons.account_circle,
                      size: 50,
                      color: Color(0xFF2B9EA4),
                    )
                  : CircleAvatar(backgroundImage: NetworkImage(tesjpg)),
              onPressed: () {
                Navigator.pushNamed(context, "/profile_pic").then(onGoBack);
              },
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
                  showAlertDialog(context);
                },
              )
            ],
            actionsIconTheme: IconThemeData(color: Color(0xFF2B9EA4), size: 36),
            toolbarHeight: 80, // default is 56
          ),
          body: Stack(children: <Widget>[
            GridView(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 120),
              children: [
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/admin_gizi');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/konsultasi.png',
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Data Cabora',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B9EA4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/admin_gizishop');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/konsultasi.png',
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Gizi-Shop',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B9EA4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        );
      },
    );
  }
}
