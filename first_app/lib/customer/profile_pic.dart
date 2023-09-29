import 'dart:io';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => ProfilePic());
  }

  @override
  State<StatefulWidget> createState() {
    return _ProfilePic();
  }
}

class _ProfilePic extends State<ProfilePic> {
  String titleu = "Tambah Produk";
  String typeu = "add";
  var argetc;
  int _selectedIndex = 0;
  bool _validateNama = false;
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? senderId = prefs.getInt('userid');

    await supabase.from('users').update({
      "pic": name,
    }).eq('id', senderId);
    SharedPreferences prefsx = await SharedPreferences.getInstance();
    await prefsx.setString('pic', name);
    text = 'Sukses disimpan';
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

  Future<List> getUserNamePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return [
      prefs.getString('usernama') ?? 'K',
      prefs.getString('email') ?? 'K',
      prefs.getBool('active') ?? false,
      prefs.getInt('userid') ?? 0,
      prefs.getString('pic') ?? ''
    ];
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    titleu = "Ganti Foto Profil";
    log("$arg");
    return FutureBuilder(
        future: getUserNamePref(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final dat = snapshot.data!;
          final imagesPathx =
              supabase.storage.from('shop_produk').getPublicUrl(dat[4]);
          log("$imagesPathx");
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
                          (imagesPath == '')
                              ? (dat[4] == '')
                                  ? Text('')
                                  : Image.network(imagesPathx, width: 100)
                              : Image.file(
                                  File(imagesPath),
                                  fit: BoxFit.cover,
                                  width: 100,
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
                                  imagesPath =
                                      result.files.single.path.toString();
                                  setState(() {
                                    imagesPath = imagesPath;
                                  });
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
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
        });
  }
}
