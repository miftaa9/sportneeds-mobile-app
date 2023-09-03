import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class NutrisionisProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NutrisionisProfile();
  }
}

class _NutrisionisProfile extends State<NutrisionisProfile> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  int? _senderId = 0;
  void initState() {
    _loadSenderId();
    super.initState();
  }

  Future<void> _loadSenderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _senderId = prefs.getInt('userid');
  }

  Future<List> getUserNamePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('usernama') ?? 'K',
      prefs.getString('email') ?? 'K'
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
            actionsIconTheme: IconThemeData(color: Color(0xFF2B9EA4), size: 36),
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
                      context, "/nutrisionis_home", (r) => false);
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
          body: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
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
                          text: '',
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text('dd'),
                  onTap: () {
                    Navigator.pushNamed(
                        context, '/nutrisionis_konsultasi_show');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
