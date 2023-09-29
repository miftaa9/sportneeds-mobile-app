import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class Transaction {
  Transaction(
      {required this.id,
      required this.idcart,
      required this.status,
      required this.sid,
      required this.iduser,
      required this.driver_id,
      required this.createdAt});

  final int id;

  final idcart;
  final status;
  final int sid;
  final int iduser;
  final int driver_id;

  final DateTime createdAt;

  Transaction.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        idcart = map['idcart'],
        status = map['status'],
        sid = map['sid'],
        iduser = map['iduser'],
        driver_id = map['driver_id'],
        createdAt = DateTime.parse(map['created_at']);
}

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
  //int useraktifs = 0;
  bool useraktif = false;
  int carijob = 0;

  void initState() {
    super.initState();
  }

  void _changeAktif(bool index) {
    setState(() {
      useraktif = index;
      carijob = 0;
    });
  }

  statAutoAktif(dynamic value) {
    setState(() {
      useraktif = true;
      carijob = 0;
    });
  }

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
      _DriverHome();
    });
  }

  late final Stream<List<Transaction>> _messagesStream = supabase
      .from('transaction')
      .stream(primaryKey: ['id'])
      .eq('statusdriver', 'cari')
      .order('created_at')
      .map((maps) => maps.map((map) => Transaction.fromMap(map: map)).toList());

  @override
  Widget build(BuildContext context) {
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
                      style: const TextStyle(
                        color: Color(0xFF2B9EA4),
                        fontSize: 30,
                      )),
                  Text(dat[1],
                      style: const TextStyle(
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
                          context, "/driver_profile", (r) => false);
                      break;
                  }
                },
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("asset/images/b/home.png"),
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
                  Container(
                      height: 60,
                      child: Container(
                          height: 100,
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
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Pendapatan',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  )),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/driver_pendapatan',
                                          arguments: {
                                            'sid': dat[3],
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.arrow_forward_ios),
                                      color: Color(0xFF2B9EA4)),
                                ],
                              ),
                            ),
                          ))),
                  Container(
                      child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.greenAccent,
                      ),
                      borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
                    ),
                    child: CupertinoListTile(
                        title: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Mulai Bekerja?',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        trailing: CupertinoSwitch(
                          value: useraktif,
                          thumbColor: Colors.white,
                          activeColor: Colors.deepPurple,
                          // trackColor: ,

                          onChanged: (value) {
                            _changeAktif(value);
                          },
                        )),
                  )),
                  if (useraktif) ...[
                    Expanded(
                      child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: StreamBuilder<List<Transaction>>(
                            stream: _messagesStream,
                            builder: (context, snapshot2) {
                              if (snapshot2.data == null) {
                                return Center(
                                    child: Container(
                                  color: Colors.white,
                                  child: LayoutBuilder(
                                      builder: (context, constraint) {
                                    return Icon(Icons.search,
                                        size: constraint.biggest.width);
                                  }),
                                ));
                              }
                              final countries = snapshot2.data!;
                              return ListView.builder(
                                itemCount: countries.length,
                                itemBuilder: ((context, index) {
                                  final country = countries[index];
                                  log("$country");
                                  log("ew ${carijob}");
                                  if (country.driver_id == 0) {
                                    carijob = 1;
                                    log("dr ${country.driver_id}");
                                    return dewaAlert(
                                        uid: country.iduser,
                                        sid: country.sid,
                                        id: country.id,
                                        idcart: country.idcart,
                                        drid: dat[3]);

                                    /*
                                    return Column(
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
                                                  text: "${country.sid}",
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text("${country.iduser}"),
                                          onTap: () {},
                                        ),
                                      ],
                                    );*/
                                  } else {
                                    return null;
                                  }
                                }),
                              );
                            },
                          )),
                    ),
                  ] else ...[
                    Expanded(flex: 9, child: Text(''))
                  ]
                ],
              ));
        });
  }
}

class dewaAlert extends StatefulWidget {
  final int uid;
  final int sid;
  final int id;
  final int drid;
  final idcart;
  const dewaAlert({
    Key? key,
    required this.uid,
    required this.sid,
    required this.id,
    required this.drid,
    required this.idcart,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _dewaAlert();
  }
}

class _dewaAlert extends State<dewaAlert> {
  void initState() {
    super.initState();
  }

  void ambilJob(id, driverid) async {
    await supabase.from('transaction').update({
      "driver_id": driverid,
      "statusdriver": "pickup",
    }).eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    var dtshop = supabase
        .from("user_nutrishop")
        .select<List<Map<String, dynamic>>>()
        .eq('user_id', widget.sid);

    var dtcust = supabase
        .from("user_customer")
        .select<List<Map<String, dynamic>>>()
        .eq('user_id', widget.uid);
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: dtshop,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat1 = snapshot.data!;

          return FutureBuilder<List<Map<String, dynamic>>>(
              future: dtcust,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final dat2 = snapshot.data!;

                log("d $dat1");
                log("e $dat2");

                return AlertDialog(
                    title: const Text('Pesanan Baru'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Ongkir: Rp. 25.000",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                              //color: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.food_bank,
                            size: 30,
                            color: Color(0xFF2B9EA4),
                          ),
                          Text(
                            "${dat1[0]['namatoko']}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "${dat1[0]['alamat']}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.account_circle,
                            size: 30,
                            color: Color(0xFF2B9EA4),
                          ),
                          Text(
                            "${dat2[0]['nama']}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "${dat2[0]['map_alamat']}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ]),
                    actions: <Widget>[
                      /*TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                            ),
                                            child: const Text('Disable'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),*/
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xFF2B9EA4)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(10)),
                        ),
                        child: const Text(
                          'Terima',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          ambilJob(widget.id, widget.drid);
                          Navigator.pushNamed(
                            context,
                            '/driver_map',
                            arguments: {
                              'shopLat': dat1[0]['latitude'],
                              'shopLon': dat1[0]['longitude'],
                              'custLat': dat2[0]['latitude'],
                              'custLon': dat2[0]['longitude'],
                              'shopDat': dat1,
                              'custDat': dat2,
                              'tid': widget.id,
                              'idcart': widget.idcart
                            },
                          );
                        },
                      ),
                    ]);
              });
        });
  }
}
