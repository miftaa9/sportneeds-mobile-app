import 'dart:io';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class NutrishopAdd extends StatefulWidget {
  const NutrishopAdd({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => NutrishopAdd());
  }

  @override
  State<StatefulWidget> createState() {
    return _NutrishopAdd();
  }
}

class _NutrishopAdd extends State<NutrishopAdd> {
  String titleu = "Tambah Produk";
  String typeu = "add";
  var argetc;
  int _selectedIndex = 0;
  bool _validateNama = false;
  TextEditingController namaController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController gambarController = TextEditingController();
  String imagesPath = "";
  String name = "";

  Future saveProcess() async {
    var text = "";
    if (imagesPath != "") {
      File avatarFile = File(imagesPath);
      name = '${DateTime.now().millisecondsSinceEpoch}.png';
      final String path = await supabase.storage.from('shop_produk').upload(
            name,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
    }
    if (typeu == 'add') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? senderId = prefs.getInt('userid');
      final data = await supabase.from('nutrishop_produk').insert({
        "nama": namaController.text.toString(),
        "harga": hargaController.text.toString(),
        "img": name,
        "user_id": senderId,
      });
      text = 'Sukses disimpan';
    } else if (typeu == 'edit') {
      final data = await supabase.from('nutrishop_produk').upsert({
        "id": argetc['id'],
        "nama": namaController.text.toString(),
        "harga": hargaController.text.toString(),
        "img": name,
        //"user_id": argetc['user_id'],
      });
      text = 'Sukses disimpan';
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
    titleu = "Tambah Produk";
    typeu = "add";
    if (arg != null) {
      var args = arg as Map;
      titleu = "Ubah Produk";
      typeu = "edit";
      argetc = args;
      namaController.text = args['nama'];
      hargaController.text = args['harga'];
      name = args['img'];
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
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
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
                width: 325,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B9EA4),
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
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          /*suffix: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.red,
                          ),*/
                          labelText: "Nama",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 260,
                      height: 60,
                      child: TextField(
                        controller: hargaController,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                          labelText: "Harga",
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 200,
                      height: 45,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png'],
                          );
                          if (result == null) {
                            print("No file selected");
                          } else {
                            imagesPath = result.files.single.path.toString();
                          }
                        },
                        child: Text(
                          "Unggah Gambar",
                          style: TextStyle(
                            color: Color(0xFF2B9EA4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          saveProcess();
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
