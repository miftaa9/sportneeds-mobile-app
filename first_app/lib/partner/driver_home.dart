import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHome extends StatefulWidget {
  const DriverHome({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => DriverHome());
  }

  @override
  State<StatefulWidget> createState() {
    return _DriverHome();
  }
}

class _DriverHome extends State<DriverHome> {
  int _selectedIndex = 0;
  int useraktifs = 0;
  bool useraktif = false;

  void initState() {
    super.initState();
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

  final _future = Supabase.instance.client
      .from('user_customer')
      .select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;

          if (useraktifs == 0) {
            useraktif = dat[2];
            useraktifs = 1;
          }
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
              bottomNavigationBar: BottomNavigationBar(
                iconSize: 40,
                selectedIconTheme:
                    IconThemeData(color: Colors.amberAccent, size: 40),
                selectedItemColor: Colors.amberAccent,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                currentIndex: _selectedIndex,
                unselectedItemColor: Colors.grey,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/driver_home", (r) => false);
                      break;
                    case 1:
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/nutrisionis_profile", (r) => false);
                      break;
                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("asset/images/b/pesan.png"),
                      color: Color(0xFF2B9EA4),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("asset/images/b/akun.png"),
                      color: Color(0xFF2B9EA4),
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
              body: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.greenAccent,
                          ),
                          borderRadius:
                              BorderRadius.circular(20.0), //<-- SEE HERE
                        ),
                        child: CupertinoListTile(
                            title: Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                )),
                            trailing: CupertinoSwitch(
                              value: useraktif,
                              thumbColor: Colors.white,
                              activeColor: Colors.deepPurple,
                              // trackColor: ,

                              onChanged: (value) {},
                            )),
                      )),
                  Expanded(
                    flex: 9,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final countries = snapshot.data!;
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
                                    leading: const Icon(
                                      Icons.account_circle,
                                      size: 50,
                                      color: Color(0xFF2B9EA4),
                                    ),
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
                                    subtitle: Text(country['alamat']),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/nutrisionis_konsultasi_show',
                                        arguments: {
                                          'customer_id': country['user_id'],
                                          'nama': country['nama'],
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ));
        });
  }
}
