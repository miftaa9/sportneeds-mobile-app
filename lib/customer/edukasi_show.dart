import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';

class CustomerEdukasiShow extends StatelessWidget {
  void click() {}
  @override
  Widget build(BuildContext context) {
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
                Image.asset('asset/images/b/edukasi.png'),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'KKK',
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
                            'Manfaat',
                            style: TextStyle(
                              color: Color(0xFF2B9EA4),
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
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
