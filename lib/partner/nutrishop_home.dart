import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

class Transaction {
  Transaction(
      {required this.id, required this.idcart, required this.createdAt});

  final int id;

  final idcart;

  final DateTime createdAt;

  Transaction.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        idcart = map['idcart'],
        createdAt = DateTime.parse(map['created_at']);
}

class NutrishopHome extends StatefulWidget {
  const NutrishopHome({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => NutrishopHome());
  }

  @override
  State<StatefulWidget> createState() {
    return _NutrishopHome();
  }
}

class _NutrishopHome extends State<NutrishopHome> {
  int _selectedIndex = 0;
  int useraktifs = 0;
  bool useraktif = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _changeActive(bool index, int id) async {
    setState(() {
      useraktif = !index;
    });
    await supabase.from('user_nutrishop').update({
      "active": useraktif,
    }).eq('user_id', id);
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

          if (useraktifs == 0) {
            useraktif = dat[2];
            useraktifs = 1;
          }
          late final Stream<List<Transaction>> _messagesStream = supabase
              .from('transaction')
              .stream(primaryKey: ['id'])
              .eq('sid', dat[3])
              //.eq('nutrisionis_id', _senderId)
              .order('created_at')
              .map((maps) =>
                  maps.map((map) => Transaction.fromMap(map: map)).toList());
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
              body: /*Column(children: <Widget>[
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 2.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      CupertinoListTile(
                          title: Padding(
                              padding: EdgeInsets.all(14.0),
                              child: Text(
                                'Status',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                          trailing: CupertinoSwitch(
                            value: useraktif,
                            thumbColor: Colors.white,
                            activeColor: Colors.deepPurple,
                            // trackColor: ,

                            onChanged: (value) {
                              log("$value");
                              _changeActive(useraktif, dat[3]);
                            },
                          )),
                    ],
                  ),
                ),*/
                  Container(
                      child: StreamBuilder<List<Transaction>>(
                          stream: _messagesStream,
                          builder: (context, snapshot) {
                            //if (snapshot.hasData) {
                            final messages = snapshot.data;
                            if (messages != null) {
                              log("${messages.length}");
                            }
                            return Column(
                              children: [
                                Expanded(
                                  child: messages == null
                                      ? const Center(
                                          child: Text(
                                            'Loading...',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: messages.length,
                                          itemBuilder: (context, index) {
                                            final message = messages[index];
                                            log("dewa");
                                            return Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 2.0),
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
                                                      selectionColor:
                                                          Color(0xFF2B9EA4),
                                                      text: TextSpan(
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                                0xFF2B9EA4)),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                'dewa' /*message[
                                                                      'sid']*/
                                                            ,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    subtitle: Text('dewa'
                                                        /*message[
                                                                  'idcart']*/
                                                        ),
                                                    onTap: () {},
                                                    trailing: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        TextButton(
                                                          onPressed: () {
                                                            //saveProcess(pid);
                                                          },
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0),
                                                            child: Text(
                                                              'Terima',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF2B9EA4),
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ],
                            );
                          })) /*])*/);
        });
  }
}
