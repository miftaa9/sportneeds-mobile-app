import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class CustomerEdukasiShow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerEdukasiShow();
  }
}

class _CustomerEdukasiShow extends State<CustomerEdukasiShow> {
  void click() {}
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final all = arg["all"];
    log("$all");
    return Scaffold(
      backgroundColor: Color(0xFF2B9EA4),
      appBar: const LayoutCustomerAppBar(
          title: Text('Edukasi',
              style: TextStyle(
                fontSize: 34,
                color: Color(0xFF2B9EA4),
              ))),
      bottomNavigationBar: LayoutCustomerBottomNav(),
      body: Stack(children: <Widget>[
        Card(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Image.network(all['img']),
                //Image.asset('asset/images/b/edukasi.png'),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      all['nama'],
                      style: TextStyle(
                          color: Color(0xFF2B9EA4),
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            all['head1'],
                            style: TextStyle(
                              color: Color(0xFF2B9EA4),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            all['text1'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            all['head2'],
                            style: TextStyle(
                              color: Color(0xFF2B9EA4),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            all['text2'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            all['head3'],
                            style: TextStyle(
                              color: Color(0xFF2B9EA4),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            all['text3'],
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ])),
              ],
            )),
      ]),
    );
  }
}
