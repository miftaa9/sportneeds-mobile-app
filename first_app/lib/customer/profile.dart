import 'package:first_app/layout/customerBottomNav.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfile createState() => _CustomerProfile();
}

class _CustomerProfile extends State<CustomerProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController tbController = TextEditingController();
  TextEditingController bbController = TextEditingController();
  var ccc = 0;
  String dropdownvalue = '1';
  var cabora;
  //String nama = '';
  @override
  void initState() {
    super.initState();
  }

/*
  Future<String> dat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nama = prefs.getString('usernama')!;
    return nama;
  }*/
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

  onGoBack(dynamic value) {
    setState(() {
      _CustomerProfile();
    });
  }

  Future registProcess(id) async {
    await supabase.from('users').update({
      "pass": passController.text.toString(),
    }).eq('id', id);
    await supabase.from('user_customer').update({
      "nama": namaController.text.toString(),
      "notelp": notelpController.text.toString(),
      "alamat": alamatController.text.toString(),
      "tb": tbController.text.toString(),
      "bb": bbController.text.toString(),
      "cabang_id": int.parse(dropdownvalue),
    }).eq('user_id', id);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_cabora_id', int.parse(dropdownvalue));
    Fluttertoast.showToast(
      msg: 'Profile sukses di-update',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
    setState(() {});
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Batal"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(context, "/first", (r) => false);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  final _futurex = supabase.from('cabang_olahraga').select();

  @override
  Widget build(BuildContext context) {
    log("$context");
    return FutureBuilder(
      future: getUserNamePref(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final dat = snapshot.data!;

        final tesjpg =
            supabase.storage.from('shop_produk').getPublicUrl(dat[4]);
        final dtuser =
            supabase.from('users').select().eq('id', dat[3]).single();

        final dtcust = supabase
            .from('user_customer')
            .select()
            .eq('user_id', dat[3])
            .single();
        return FutureBuilder(
            future: dtuser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final datUser = snapshot.data!;

              return FutureBuilder(
                  future: dtcust,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final datCust = snapshot.data!;
                    log("$datCust");

                    if (ccc == 0) {
                      emailController.text = datUser['email'];
                      passController.text = datUser['pass'];
                      namaController.text = datCust['nama'];
                      notelpController.text = datCust['notelp'];
                      alamatController.text = datCust['alamat'];
                      tbController.text = datCust['tb'].toString();
                      bbController.text = datCust['bb'].toString();
                      dropdownvalue = datCust['cabang_id'].toString();
                      ccc = 1;
                    }

                    return Scaffold(
                      backgroundColor: Color(0xFF2B9EA4),
                      appBar: AppBar(
                        title: Column(children: [
                          Text(dat[0],
                              style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 30,
                              )),
                          Text(dat[1],
                              style: TextStyle(
                                color: Color(0xFF2B9EA4),
                              )),
                        ]),
                        leading: IconButton(
                          icon: (dat[4] == '')
                              ? const Icon(
                                  Icons.account_circle,
                                  size: 50,
                                  color: Color(0xFF2B9EA4),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(tesjpg)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/profile_pic")
                                .then(onGoBack);
                          },
                        ),
                        backgroundColor:
                            Colors.white, //You can make this transparent
                        elevation: 0.0, //No shadow
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: Color(0xFF2B9EA4),
                            ),
                            onPressed: () {
                              showAlertDialog(context);
                            },
                          )
                        ],
                        actionsIconTheme:
                            IconThemeData(color: Color(0xFF2B9EA4), size: 36),
                        toolbarHeight: 80, // default is 56
                      ),
                      body: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                width: 325,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2B9EA4),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
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
                                        enabled: false,
                                        controller: emailController,
                                        style: const TextStyle(
                                            color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.envelope,
                            color: Colors.red,
                          ),*/
                                          labelText: "Email Address",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
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
                                        controller: passController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          labelText: "Password",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
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
                                        controller: namaController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                                          labelText: "Nama",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
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
                                        controller: notelpController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                                          labelText: "No Telp",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
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
                                        controller: alamatController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                                          labelText: "Alamat",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 260,
                                      height: 60,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: tbController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                                          labelText: "Tinggi Badan",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
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
                                        keyboardType: TextInputType.number,
                                        controller: bbController,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          /*suffix: Icon(
                            FontAwesomeIcons.eyeSlash,
                            color: Colors.red,
                          ),*/
                                          labelText: "Berat Badan",
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    FutureBuilder(
                                        future: _futurex,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          final dat = snapshot.data!;
                                          log("zz ${dropdownvalue}");

                                          return Container(
                                            width: 260,
                                            height: 60,
                                            child: DropdownButton(
                                              dropdownColor: Color(0xFF2B9EA4),
                                              isExpanded: true,
                                              iconEnabledColor: Colors.white,
                                              underline: Container(
                                                width: 200,
                                                height: 1,
                                                color: Colors.white,
                                              ),
                                              // Initial Value
                                              value: dropdownvalue,

                                              // Down Arrow Icon
                                              icon: const Icon(
                                                  Icons.keyboard_arrow_down),

                                              items: snapshot.data
                                                  .map<
                                                      DropdownMenuItem<
                                                          String>>((fc) =>
                                                      DropdownMenuItem<String>(
                                                        value: (fc['id']
                                                            .toString()),
                                                        child: Text(
                                                          fc['nama'],
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              // After selecting the desired option,it will
                                              // change button value to selected value
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownvalue = newValue!;
                                                });
                                              },
                                            ),
                                          );
                                        }),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 10.0),
                                      alignment: Alignment.center,
                                      width: 250,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Colors.white,
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          registProcess(dat[3]);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Text(
                                            'Update',
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
                      bottomNavigationBar: LayoutCustomerBottomNav(),
                    );
                  });
            });
      },
    );
  }
}
