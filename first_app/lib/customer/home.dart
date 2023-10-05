import 'package:first_app/layout/customerBottomNav.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class Customer_Home extends StatefulWidget {
  const Customer_Home({super.key});

  @override
  _Customer_Home createState() => _Customer_Home();
}

class _Customer_Home extends State<Customer_Home> {
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
      prefs.getString('pic') ?? '',
      prefs.getInt('user_cabora_id') ?? 0,
    ];
  }

  onGoBack(dynamic value) {
    setState(() {
      _Customer_Home();
    });
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
                      Navigator.pushNamed(context, '/customer_edukasi');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/edukasi.png',
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Edukasi',
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
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/customer_kalori',
                        arguments: {
                          'user_id': dat[3],
                          'cabang_id': dat[5],
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/nutrisiharian.png',
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Kalori Harian',
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
                      Navigator.pushNamed(context, '/customer_konsultasi');
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
                            'Konsultasi',
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
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/customer_shop');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/nutrishop.png',
                          color: Color(0xFF2B9EA4),
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Nutrishop',
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
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/customer_riwayat',
                        arguments: {
                          'uid': dat[3],
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/kalender.png',
                          color: Color(0xFF2B9EA4),
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Kalender',
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
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/cust_kalender',
                        arguments: {
                          'uid': dat[3],
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/kalender.png',
                          color: Color(0xFF2B9EA4),
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Kalender Gizi',
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
                /*Card(
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/test5',
                        arguments: {
                          'uid': dat[3],
                        },
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset(
                          'asset/images/b/kalender.png',
                          color: Color(0xFF2B9EA4),
                          width: 80,
                        ),
                        const SizedBox(height: 4),
                        const Center(
                          child: Text(
                            'Kalender Gizi',
                            style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2B9EA4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ]),
          bottomNavigationBar: LayoutCustomerBottomNav(),
        );
      },
    );
  }
}
