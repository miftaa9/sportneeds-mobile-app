import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strintcurrency/strintcurrency.dart';

class CustNutrisiDetail extends StatefulWidget {
  @override
  State<CustNutrisiDetail> createState() => _CustNutrisiDetail();
}

class _CustNutrisiDetail extends State<CustNutrisiDetail> {
  onGoBack(dynamic value) {
    setState(() {
      _CustNutrisiDetail();
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

  terimaProcess(idtoko, idcart, idtrans) async {
    for (var idcartz in idcart) {
      await supabase
          .from('cart')
          .update({'status': 'process'}).match({'id': idcartz});
    }
    await supabase
        .from('transaction')
        .update({'status': 'process'}).match({'id': idtrans});
    /*await supabase
        .from('transaction_process')
        .insert({'sid': idtoko, 'idcart': idcart});
    await supabase.from('transaction').delete().match({'id': idtrans});*/
    Fluttertoast.showToast(
      msg: 'Pesanan diterima',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final tid = arg["tid"];
    final idcart = arg["idcart"];
    final status = arg["status"];

    final datacart = supabase
        .from('cart')
        .select(
            'id, jumlah, status, nutrishop_produk(id, nama,harga,img, energi, water, protein, fat, karbo, chr,vita,vitc,vite,mag,sod )')
        .in_('id', idcart);
    return FutureBuilder(
        future: datacart,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final countries = snapshot.data!;
          return Scaffold(
            backgroundColor: Color(0xFF2B9EA4),
            appBar: const LayoutCustomerAppBar(
                title: Text('Nutrisi Detail',
                    style: TextStyle(
                      fontSize: 34,
                      color: Color(0xFF2B9EA4),
                    ))),
            bottomNavigationBar: LayoutCustomerBottomNav(),
            body: Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: countries.length,
                  itemBuilder: ((context, index) {
                    final country = countries[index];
                    final produk = country['nutrishop_produk'];
                    var jumlah = country['jumlah'];
                    var harga = int.parse(produk['harga']);
                    int total = jumlah * harga;
                    countries[index]['total'] = total;
                    var totalStr = total.toString();
                    final strintcurrency = StrIntCurrency();

                    final tesjpg = supabase.storage
                        .from('shop_produk')
                        .getPublicUrl(produk['img']);
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
                                  TextSpan(text: "Nama : ${produk['nama']}"),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            title: RichText(
                              selectionColor: Color(0xFF2B9EA4),
                              text: TextSpan(
                                style:
                                    const TextStyle(color: Color(0xFF2B9EA4)),
                                children: [
                                  TextSpan(
                                      text: "Energi : ${produk['energi']}\n"),
                                  TextSpan(
                                      text: "Water : ${produk['water']}\n"),
                                  TextSpan(
                                      text: "Protein : ${produk['protein']}\n"),
                                  TextSpan(text: "Fat : ${produk['fat']}\n"),
                                  TextSpan(
                                      text:
                                          "Karbohidrat : ${produk['karbo']}\n"),
                                  TextSpan(
                                      text: "Cholesterol : ${produk['chr']}\n"),
                                  TextSpan(
                                      text: "Vitamin A : ${produk['vita']}\n"),
                                  TextSpan(
                                      text: "Vitamin C : ${produk['vitc']}\n"),
                                  TextSpan(
                                      text: "Vitamin E : ${produk['vite']}\n"),
                                  TextSpan(
                                      text: "Magnesium : ${produk['mag']}\n"),
                                  TextSpan(text: "Sodium : ${produk['sod']}\n"),
                                ],
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ]),
          );
        });
  }
}
