import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class NutrishopProduk extends StatefulWidget {
  const NutrishopProduk({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => NutrishopProduk());
  }

  @override
  State<StatefulWidget> createState() {
    return _NutrishopProduk();
  }
}

class _NutrishopProduk extends State<NutrishopProduk> {
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
    await Supabase.instance.client
        .from('nutrishop_produk')
        .delete()
        .match({'id': id});
  }

  onGoBack(dynamic value) {
    tes();
    setState(() {
      _NutrishopProduk();
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

          final _future = Supabase.instance.client
              .from('nutrishop_produk')
              .select<List<Map<String, dynamic>>>()
              .eq('user_id', dat[3]);
          return Scaffold(
            backgroundColor: Color(0xFF2B9EA4),
            appBar: AppBar(
              title: Column(children: [
                Row(children: [
                  const Text('Produk Saya',
                      style: TextStyle(
                        fontSize: 34,
                        color: Color(0xFF2B9EA4),
                      )),
                ]),
                Row(children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF2B9EA4)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/nutrishop_produk_add')
                          .then(onGoBack);
                    },
                    child: Text(
                      "Tambah Produk",
                      style: TextStyle(
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ]),
              ]),
              backgroundColor: Colors.white,
              elevation: 0.0,
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
                        context, "/nutrishop_home", (r) => false);
                    break;
                  case 1:
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/nutrishop_produk", (r) => false);
                    break;
                  case 2:
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/nutrishop_profile", (r) => false);
                    break;
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("asset/images/b/pesanan-partners.png"),
                    color: Color(0xFF2B9EA4),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage("asset/images/b/produk-saya.png"),
                    color: Color(0xFF2B9EA4),
                  ),
                  label: 'Cart',
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
                            subtitle: Text(country['harga']),
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                              context, '/nutrishop_produk_add',
                                              arguments: country)
                                          .then(onGoBack);
                                    },
                                    icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      showAlertDialog(context, country['id']);
                                    },
                                    icon: const Icon(Icons.delete)),
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
          );
        });
  }
}
