import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';

class CustomerEdukasi extends StatelessWidget {
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
              ListTile(
                leading: Image.asset('asset/images/b/edukasi.png'),
                title: const Text('Demo Title'),
                subtitle: const Text('This is a simple card in Flutter.'),
                onTap: () {
                  Navigator.pushNamed(context, '/customer_edukasi_show');
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
