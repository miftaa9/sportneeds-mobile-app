import 'package:flutter/material.dart';
import 'package:first_app/first.dart';

class stageNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Nav'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => First()));
              },
              child: Text('Customer')),
        ],
      )),
    );
  }
}
