import 'dart:io';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class AdminCaboraGiziTr extends StatefulWidget {
  @override
  _AdminCaboraGiziTr createState() => _AdminCaboraGiziTr();
}

class _AdminCaboraGiziTr extends State<AdminCaboraGiziTr> {
  Map<String, TextEditingController> _controllerMap = Map();

  @override
  void dispose() {
    _controllerMap.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Dynamic Text Field with async"),
          ),
          body: Column(
            children: [
              Expanded(child: _futureBuilder()),
              _cancelOkButton(),
            ],
          )),
    );
  }

/*
  List<String> _data = [
    "one",
    "two",
    "three",
    "four",

  ];
  Future<List<String>> _retrieveData() {
    return Future.value(_data);
  }*/
  final _retrieveData =
      supabase.from('daftar_gizi').select<List<Map<String, dynamic>>>();

  Widget _cancelOkButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _okButton(),
      ],
    );
  }

  Widget _cancelButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _controllerMap.forEach((key, controller) {
            controller.text = key;
          });
        });
      },
      child: Text("Cancel"),
    );
  }

  Widget _okButton() {
    return ElevatedButton(
      onPressed: () async {
        String text = _controllerMap.values
            .where((element) => element.text != "")
            .fold("", (acc, element) => acc += "${element.text}\n");
        await _showUpdatedDialog(text);

        setState(() {
          _controllerMap.forEach((key, controller) {
            int index = _controllerMap.keys.toList().indexOf(key);
            key = controller.text;
            //_data[index] = controller.text;
          });
        });
      },
      child: Text("OK"),
    );
  }

  Future _showUpdatedDialog(String text) {
    final alert = AlertDialog(
      title: Text("Updated"),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
    return showDialog(
      context: context,
      builder: (BuildContext context) => alert,
    );
  }

  Widget _futureBuilder() {
    return FutureBuilder(
      future: _retrieveData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Align(
            alignment: Alignment.topCenter,
            child: Text("No item"),
          );
        }

        final data = snapshot.data!;
        return ListView.builder(
          itemCount: data.length,
          padding: EdgeInsets.all(5),
          itemBuilder: (BuildContext context, int index) {
            final controller = _getControllerOf(data[index]['nama']);

            final textField = TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "${data[index]['nama']}",
              ),
            );
            return Container(
              child: textField,
              padding: EdgeInsets.only(bottom: 10),
            );
          },
        );
      },
    );
  }

  TextEditingController _getControllerOf(String name) {
    var controller = _controllerMap[name];
    if (controller == null) {
      controller = TextEditingController(text: name);
      _controllerMap[name] = controller;
    }
    return controller;
  }
}
