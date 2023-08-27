import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomerKonsultasi extends StatefulWidget {
  const CustomerKonsultasi({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => CustomerKonsultasi());
  }

  @override
  State<StatefulWidget> createState() {
    return _CustomerKonsultasi();
  }
}

class _CustomerKonsultasi extends State<CustomerKonsultasi> {
  int? _senderId = 0;
  void initState() {
    _loadSenderId();
    super.initState();
  }

  Future<void> _loadSenderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _senderId = prefs.getInt('userid');
  }

  final _future = Supabase.instance.client
      .from('user_nutrisionis')
      .select<List<Map<String, dynamic>>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2B9EA4),
      appBar: const LayoutCustomerAppBar(
          title: Text('Konsultasi',
              style: TextStyle(
                fontSize: 34,
                color: Color(0xFF2B9EA4),
              ))),
      bottomNavigationBar: LayoutCustomerBottomNav(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: ((context, index) {
              final country = countries[index];
              var nama = country['nama'];
              if (country['active'] == false) {
                nama = country['nama'] + " (tidak aktif)";
              }
              return Card(
                margin: const EdgeInsets.only(
                  left: 20,
                  top: 5,
                  right: 20,
                  bottom: 5,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Color(0xFF2B9EA4),
                      ),
                      title: RichText(
                        selectionColor: Color(0xFF2B9EA4),
                        text: TextSpan(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B9EA4)),
                          children: [
                            TextSpan(
                              text: nama,
                            ),
                          ],
                        ),
                      ),
                      subtitle: Text(''),
                      onTap: () {
                        if (country['active'] == true) {
                          Navigator.pushNamed(
                            context,
                            '/customer_konsultasi_show',
                            arguments: {
                              'nutrisionis_id': country['user_id'],
                              'nama': country['nama'],
                              'customer_id': _senderId,
                            },
                          );
                        } else if (country['active'] == false) {
                          Fluttertoast.showToast(
                            msg: 'Nutrisionis Tidak aktif',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
      /*Stack(children: <Widget>[
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
                  _signIn();
                  //Navigator.pushNamed(context, '/customer_edukasi_show');
                },
              ),
            ],
          ),
        ),
      ]),*/
    );
  }
}
