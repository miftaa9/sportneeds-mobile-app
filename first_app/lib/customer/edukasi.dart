import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';

class CustomerEdukasi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerEdukasi();
  }
}

class _CustomerEdukasi extends State<CustomerEdukasi> {
  final _future = supabase.from('edukasi').select<List<Map<String, dynamic>>>();

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
                      /*leading: const Icon(
                        Icons.account_circle,
                        size: 50,
                        color: Color(0xFF2B9EA4),
                      ),*/
                      title: RichText(
                        selectionColor: Color(0xFF2B9EA4),
                        text: TextSpan(
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2B9EA4)),
                          children: [
                            TextSpan(
                              text: country['nama'],
                            ),
                          ],
                        ),
                      ),
                      //subtitle: Text(''),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/customer_edukasi_show',
                          arguments: {
                            'id': country['id'],
                            'nama': country['nama'],
                            'img': country['img'],
                            'all': country,
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
