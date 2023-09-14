import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strintcurrency/strintcurrency.dart';
import 'package:intl/intl.dart';

class CustomerCartCheckout extends StatefulWidget {
  const CustomerCartCheckout({Key? key}) : super(key: key);
  //int totalsemua;
  //CustomerCartCheckout({this.totalsemua = 0});
  @override
  State<CustomerCartCheckout> createState() => _CustomerCartCheckout();
}

class _CustomerCartCheckout extends State<CustomerCartCheckout> {
  late int totalsemua = 0;
  late int totalsemuab;
  var _info = ["", "", ""];
  onGoBack(dynamic value) {
    setState(() {
      _CustomerCartCheckout();
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
  void initState() {
    super.initState();
  }

  checkoutProcess(iduser, idcart, idtoko, totalharga) async {
    for (var idcartz in idcart) {
      await supabase
          .from('cart')
          .update({'status': 'waiting'}).match({'id': idcartz});
    }
    String dateO = DateFormat("yyyy-MM-dd").format(DateTime.now());
    await supabase.from('transaction').insert({
      'sid': idtoko,
      'idcart': idcart,
      'iduser': iduser,
      'status': 'waiting',
      'datez': dateO,
      'total': totalharga,
    });
    await supabase.from('user_customer').update({
      "latitude": _info[0],
      "longitude": _info[1],
      "map_alamat": _info[2],
    }).eq('user_id', iduser);
    Fluttertoast.showToast(
      msg: 'Pesanan telah masuk ke Nutrishop',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  void moveToSecondPage() async {
    final information =
        await Navigator.pushNamed(context, '/reg_nutrishop_lokasi');
    log("$information");
    updateInformation(information);
  }

  void updateInformation(information) {
    setState(() => _info = information);
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final cids = arg["cart_ids"];
    final int shopid = arg["shop_id"];
    final int uid = arg["uid"];
    final int totalharga = arg["totalharga"];
    final cartlat = arg["cartlat"];
    final cartlng = arg["cartlng"];
    final cartalamat = arg["cartalamat"];
    _info[0] = cartlat;
    _info[1] = cartlng;
    _info[2] = cartalamat;
    String totalsemuastr = totalsemua.toString();
    //final xfuture = supabase.from('cart').select<List<Map<String, dynamic>>>();
    return FutureBuilder<List>(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;
          final xfuture = supabase.rpc('cart2', params: {'idz': dat[3]});

          final datacart = supabase
              .from('cart')
              .select('id, jumlah, status, nutrishop_produk(id, nama,harga)')
              .in_('id', cids);
          return FutureBuilder(
              future: datacart,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final countries = snapshot.data!;
                totalsemua = 0;

                final datacust = supabase
                    .from('user_customer')
                    .select()
                    .eq('id', dat[3])
                    .single();
                return Scaffold(
                  backgroundColor: Color(0xFF2B9EA4),
                  appBar: const LayoutCustomerAppBar(
                      title: Text('Checkout',
                          style: TextStyle(
                            fontSize: 34,
                            color: Color(0xFF2B9EA4),
                          ))),
                  body: Column(children: [
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
                          child: ListTile(
                            title: RichText(
                              selectionColor: Color(0xFF2B9EA4),
                              text: TextSpan(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B9EA4)),
                                children: [
                                  TextSpan(text: "Alamat : ${_info[2]}"),
                                ],
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lat : ${_info[0]}"),
                                Text("Lng : ${_info[1]}"),
                              ],
                            ),
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      moveToSecondPage();
                                    },
                                    icon: const Icon(Icons.add_location_alt),
                                    color: Color(0xFF2B9EA4)),
                              ],
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 5,
                      child: ListView.builder(
                        itemCount: countries.length,
                        itemBuilder: ((context, index) {
                          final country = countries[index];
                          final produk = country['nutrishop_produk'];
                          var jumlah = country['jumlah'];
                          var harga = int.parse(produk['harga']);
                          int total = jumlah * harga;
                          countries[index]['total'] = total;
                          totalsemua = totalsemua + total;
                          var totalStr = total.toString();
                          final strintcurrency = StrIntCurrency();
                          /*final harga2 = strintcurrency.intToStringID(
                              produk['harga'],
                              symbol: false); */ // it returns "2,000,00"
                          //final jsona = json.encode(country['produks']);
                          //log("${jsona[0]}");
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
                                            text: "Nama : ${produk['nama']}"),
                                      ],
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("@Harga : ${produk['harga']}"),
                                      Text("Jumlah : ${country['jumlah']}"),
                                    ],
                                  ),
                                  onTap: () {},
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(totalStr,
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 20,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ]),
                  bottomNavigationBar: BottomAppBar(
                    child: Container(
                      height: 150,
                      child: Column(
                        children: <Widget>[
                          Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text("Total",
                                      style: TextStyle(
                                        color: Color(0xFF2B9EA4),
                                        fontSize: 30,
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text("${totalharga}",
                                      style: TextStyle(
                                        color: Color(0xFF2B9EA4),
                                        fontSize: 30,
                                      )),
                                )
                              ]),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                // The width will be 100% of the parent widget
                                // The height will be 60
                                backgroundColor: const Color(0xFF2B9EA4),
                                minimumSize: const Size.fromHeight(60)),
                            onPressed: () {
                              checkoutProcess(uid, cids, shopid, totalharga);

                              Navigator.pop(context);
                            },
                            child: const Text("Pesan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
