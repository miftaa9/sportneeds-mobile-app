import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomerCart extends StatefulWidget {
  @override
  State<CustomerCart> createState() => _CustomerCart();
}

class _CustomerCart extends State<CustomerCart> {
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
      title: Text("Yakin Hapus dari Cart?"),
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

  onGoBack(dynamic value) {
    setState(() {
      _CustomerCart();
    });
  }

  deleteData(id) async {
    await supabase.from('cart').delete().match({'id': id});
  }

  checkoutProcess(iduser, idcart, idtoko) async {
    for (var idcartz in idcart) {
      await supabase
          .from('cart')
          .update({'status': 'waiting'}).match({'id': idcartz});
    }
    await supabase
        .from('transaction')
        .insert({'sid': idtoko, 'idcart': idcart});
    Fluttertoast.showToast(
      msg: 'Pesanan telah masuk ke Nutrishop',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
    onGoBack(() {});
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final xfuture = supabase.from('cart').select<List<Map<String, dynamic>>>();
    return FutureBuilder<List>(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;
          final xfuture = supabase.rpc('cart2', params: {'idz': dat[3]});
          return Scaffold(
            backgroundColor: Color(0xFF2B9EA4),
            appBar: AppBar(
              title: Column(children: [
                Text("Cart",
                    style: TextStyle(
                      color: Color(0xFF2B9EA4),
                      fontSize: 30,
                    )),
              ]),
              backgroundColor: Colors.white, //You can make this transparent
              elevation: 0.0, //No shadow
              actionsIconTheme:
                  IconThemeData(color: Color(0xFF2B9EA4), size: 36),
              toolbarHeight: 80, // default is 56
            ),
            bottomNavigationBar: LayoutCustomerBottomNav(),
            body: Column(
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: xfuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final countries = snapshot.data!;
                      return ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: ((context, index) {
                          final country = countries[index];
                          final jsona = country['produks'];
                          //final jsona = json.encode(country['produks']);
                          //log("${jsona[0]}");
                          num totalharga = 0;
                          var cartlat;
                          var cartlng;
                          var cartalamat;
                          return Card(
                              margin: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  //Image.asset('asset/images/b/edukasi.png'),
                                  Container(
                                      margin: EdgeInsets.all(30),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Toko : ${country['nama'][0]}",
                                              style: TextStyle(
                                                color: Color(0xFF2B9EA4),
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Container(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: jsona.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final jsjumlah =
                                                      country['jumlah'][index];
                                                  final jspid =
                                                      country['produks'][index];
                                                  final jspnama =
                                                      country['pnama'][index];
                                                  final jspharga =
                                                      country['pharga'][index];
                                                  var hargaz =
                                                      int.parse(jspharga);
                                                  totalharga +=
                                                      hargaz * jsjumlah;
                                                  cartlat =
                                                      country['dlat'][index];
                                                  cartlng =
                                                      country['dlng'][index];
                                                  cartalamat =
                                                      country['dalamat'][index];
                                                  return Card(
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 2.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        ListTile(
                                                          leading: const Icon(
                                                            Icons
                                                                .account_circle,
                                                            size: 50,
                                                            color: Color(
                                                                0xFF2B9EA4),
                                                          ),
                                                          title: RichText(
                                                            selectionColor:
                                                                Color(
                                                                    0xFF2B9EA4),
                                                            text: TextSpan(
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color(
                                                                      0xFF2B9EA4)),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "Nama : ${jspnama}"),
                                                              ],
                                                            ),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Harga : ${jspharga}"),
                                                              Text(
                                                                  "Jumlah : ${jsjumlah}"),
                                                            ],
                                                          ),
                                                          onTap: () {},
                                                          trailing: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    showAlertDialog(
                                                                        context,
                                                                        jspid);
                                                                  },
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete),
                                                                  color: Color(
                                                                      0xFF2B9EA4)),
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: RichText(
                                                            selectionColor:
                                                                Color(
                                                                    0xFF2B9EA4),
                                                            text: TextSpan(
                                                              style: const TextStyle(
                                                                  color: Color(
                                                                      0xFF2B9EA4)),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        "Energi : ${country['energi'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Water : ${country['water'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Protein : ${country['protein'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Fat : ${country['fat'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Karbohidrat : ${country['karbo'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Cholesterol : ${country['chr'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Vitamin A : ${country['vita'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Vitamin C : ${country['vitc'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Vitamin E : ${country['vite'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Magnesium : ${country['mag'][0]}\n"),
                                                                TextSpan(
                                                                    text:
                                                                        "Sodium : ${country['sod'][0]}\n"),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {},
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/customer_cart_checkout',
                                                  arguments: {
                                                    'uid': dat[3],
                                                    'cart_ids':
                                                        country['produks'],
                                                    'shop_id': country['ids'],
                                                    'totalharga': totalharga,
                                                    'cartlat': cartlat,
                                                    'cartlng': cartlng,
                                                    'cartalamat': cartalamat,
                                                  },
                                                ).then(onGoBack);
                                                /*
                                                checkoutProcess(
                                                    dat[3],
                                                    country['produks'],
                                                    country['ids']);*/
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(12.0),
                                                child: Text(
                                                  'Checkout',
                                                  style: TextStyle(
                                                      color: Color(0xFF2B9EA4),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 17,
                                            ),
                                          ])),
                                ],
                              ));
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
