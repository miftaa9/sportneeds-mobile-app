import 'dart:io';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class adminCaboraCu extends StatefulWidget {
  const adminCaboraCu({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => adminCaboraCu());
  }

  @override
  State<StatefulWidget> createState() {
    return _adminCaboraCu();
  }
}

class _adminCaboraCu extends State<adminCaboraCu> {
  String titleu = "Tambah Produk";
  String typeu = "add";
  var argetc;
  int _selectedIndex = 0;
  bool _validateNama = false;
  TextEditingController namaController = TextEditingController();
  String imagesPath = "";
  String name = "";
  var argstatus = 0;

  Future saveProcess() async {
    print('a');
    var text = "";
    if (typeu == 'add') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? senderId = prefs.getInt('userid');
      final data = await supabase.from('cabang_olahraga').insert({
        "nama": namaController.text.toString(),
      });
      text = 'Sukses disimpan';
    } else if (typeu == 'edit') {
      final data = await supabase.from('cabang_olahraga').upsert({
        "id": argetc['id'],
        "nama": namaController.text.toString(),
      });
      text = 'Sukses diganti';
    }
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
    Navigator.pop(context);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (argstatus == 0) {
      titleu = "Tambah Produk";
      typeu = "add";
      if (arg != null) {
        var args = arg as Map;
        titleu = "Ubah Produk";
        typeu = "edit";
        argetc = args;
        namaController.text = args['nama'];
        argstatus += 1;
      }
    }
    log("$arg");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFF2B9EA4),
      appBar: LayoutCustomerAppBar(
          title: Text(titleu,
              style: const TextStyle(
                fontSize: 34,
                color: Color(0xFF2B9EA4),
              ))),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(),
          /*decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ])),*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: TextField(
                        controller: namaController,
                        style: const TextStyle(color: Color(0xFF2B9EA4)),
                        decoration: const InputDecoration(
                          /*suffix: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.red,
                          ),*/
                          labelText: "Nama",
                          labelStyle: TextStyle(color: Color(0xFF2B9EA4)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF2B9EA4)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF2B9EA4)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    InkWell(
                      onTap: () {
                        saveProcess();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        alignment: Alignment.center,
                        width: 250,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: Color(0xFF2B9EA4),
                        ),
                        child: TextButton(
                          onPressed: () {
                            saveProcess();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(12.0),
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
