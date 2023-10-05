import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_app/main.dart';

class CustomerShopAddcart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerShopAddcart();
  }
}

class _CustomerShopAddcart extends State<CustomerShopAddcart> {
  final int minValue = 1;
  final int maxValue = 5;
  int counter = 1;
  void counterGanti(int newVal) {
    counter = newVal;
  }

  Future saveProcess(int pid) async {
    var text = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? senderId = prefs.getInt('userid');
    final data = await supabase.from('cart').insert({
      "user_id": senderId,
      "produk_id": pid,
      "jumlah": counter,
      "status": "cart",
    });
    text = 'Sudah Masuk Cart';
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
    //Navigator.pop(context);
    Navigator.pushNamed(context, "/customer_cart");
  }

  var ab = [
    'Energy',
    'Water',
    'Protein',
    'Fat',
    'Carbohydr',
    'Dietary',
    'Alcohol',
    'PUFA',
    'Cholesterol',
    'Vit. A',
    'Carotene',
    'Vit. E',
    'Vit. B1',
    'Vit. B2',
    'Vit. B6',
    'Tot. Fol.Acid',
    'Vit. C',
    'Sodium',
    'Potassium',
    'Calcium',
    'Magnesium',
    'Phosphorus',
    'Iron',
    'Zinc',
  ];
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final int pid = arg["produk_id"];
    final String namatoko = arg["namatoko"];
    final all = arg["data"];
    final tesjpg =
        supabase.storage.from('shop_produk').getPublicUrl(all['img']);
    var cc2 = 0;
    return Scaffold(
        backgroundColor: Color(0xFF2B9EA4),
        appBar: LayoutCustomerAppBar(
            title: Text(namatoko,
                style: const TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        bottomNavigationBar: LayoutCustomerBottomNav(),
        body: SingleChildScrollView(
            child: Container(
          child: Card(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.network(tesjpg, height: 100),
                  //Image.asset('asset/images/b/edukasi.png'),
                  Container(
                      margin: EdgeInsets.all(30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Produk : ${all['nama']}",
                              style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Harga Produk : ${all['harga']}",
                              style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    color: Color(0xFF2B9EA4),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 18.0),
                                  iconSize: 32.0,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      if (counter > minValue) {
                                        counter--;
                                      }
                                      counterGanti(counter);
                                    });
                                  },
                                ),
                                Text(
                                  '$counter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.add,
                                    color: Color(0xFF2B9EA4),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 18.0),
                                  iconSize: 32.0,
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () {
                                    setState(() {
                                      if (counter < maxValue) {
                                        counter++;
                                      }
                                      counterGanti(counter);
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () {
                                    saveProcess(pid);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text(
                                      'Simpan',
                                      style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 17,
                                ),
                              ],
                            ),
                            Divider(
                              color: Color(0xFF2B9EA4),
                              thickness: 2,
                            ),
                            Center(
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Kandungan ',
                                  style: TextStyle(
                                      color: Color(0xFF2B9EA4), fontSize: 30),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'Gizi',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                            DataTable(
                              sortAscending: true,
                              sortColumnIndex: 1,
                              showBottomBorder: false,
                              columns: const [
                                DataColumn(
                                    label: Text('No',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                        )),
                                    numeric: true),
                                DataColumn(
                                    label: Text('Nama',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                        ))),
                                DataColumn(
                                    label: Text('Nilai',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                        )),
                                    numeric: true),
                              ],
                              rows: [
                                ...ab.asMap().keys.toList().map((i) {
                                  var cc =
                                      (all['a' + (i + 1).toString()] == null)
                                          ? ''
                                          : all['a' + (i + 1).toString()];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((i + 1).toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                          ))),
                                      DataCell(Text(ab[i],
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                          ))),
                                      DataCell(Text('${cc}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                          )))
                                    ],
                                  );
                                })
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ])),
                ],
              )),
        )));
  }
}
