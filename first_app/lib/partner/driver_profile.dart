import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class DriverProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DriverProfile();
}

class _DriverProfile extends State<DriverProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController namaController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  int _selectedIndex = 0;
  var ccc = 0;
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
      _DriverProfile();
    });
  }

  Future registProcess(id) async {
    await supabase.from('users').update({
      "pass": passController.text.toString(),
    }).eq('id', id);
    await supabase.from('user_driver').update({
      "nama": namaController.text.toString(),
      "notelp": notelpController.text.toString(),
      "alamat": alamatController.text.toString(),
    }).eq('user_id', id);
    Fluttertoast.showToast(
      msg: 'Profil sukses di-update',
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
            .from('user_driver')
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
                          height: MediaQuery.of(context).size.height,
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
                                height: 500,
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
                      bottomNavigationBar: BottomNavigationBar(
                        iconSize: 40,
                        selectedIconTheme:
                            IconThemeData(color: Colors.amberAccent, size: 40),
                        selectedItemColor: Colors.amberAccent,
                        showSelectedLabels: false,
                        showUnselectedLabels: false,
                        currentIndex: _selectedIndex,
                        unselectedItemColor: Colors.grey,
                        onTap: (index) {
                          switch (index) {
                            case 0:
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/driver_home", (r) => false);
                              break;
                            case 1:
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/driver_profile", (r) => false);
                              break;
                          }
                        },
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: ImageIcon(
                              AssetImage("asset/images/b/home.png"),
                              color: Color(0xFF2B9EA4),
                            ),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: ImageIcon(
                              AssetImage("asset/images/b/akun.png"),
                              color: Color(0xFF2B9EA4),
                            ),
                            label: 'Profile',
                          ),
                        ],
                      ),
                    );
                  });
            });
      },
    );
  }
}
