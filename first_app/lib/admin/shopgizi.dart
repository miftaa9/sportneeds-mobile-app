import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:first_app/main.dart';

class adminShopGizi extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _adminShopGizi();
  }
}

class _adminShopGizi extends State<adminShopGizi> {
  TextEditingController emailController = TextEditingController();
  String search = "";
  @override
  Widget build(BuildContext context) {
    final _future = supabase
        .from('user_nutrishop')
        .select<List<Map<String, dynamic>>>()
        .ilike('namatoko', "%$search%");
    return Scaffold(
        backgroundColor: Color(0xFF2B9EA4),
        appBar: const LayoutCustomerAppBar(
            title: Text('Data Gizi-Shop',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF2B9EA4),
                ))),
        body: Column(children: <Widget>[
          Container(
              height: 60,
              child: Container(
                  height: 100,
                  child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.greenAccent,
                        ),
                        borderRadius:
                            BorderRadius.circular(20.0), //<-- SEE HERE
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(2.0),
                          child: ListTile(
                            title: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'pencarian...',
                                hintStyle: TextStyle(
                                  color: Color(0xFF2B9EA4),
                                  fontSize: 24,
                                  fontStyle: FontStyle.italic,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  // width: 0.0 produces a thin "hairline" border
                                  borderSide: const BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              style: TextStyle(
                                color: Color(0xFF2B9EA4),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        search = emailController.text;
                                      });
                                    },
                                    icon: const Icon(Icons.search),
                                    color: Color(0xFF2B9EA4)),
                              ],
                            ),
                          ))))),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 2.0),
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
                                    text: country['namatoko'],
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Text(country['nama']),
                            onTap: () {},
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/admin_gizishop_detail',
                                        arguments: {
                                          'user_id': country['user_id'],
                                          'namatoko': country['namatoko'],
                                          'nama': country['nama'],
                                        },
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                    color: Color(0xFF2B9EA4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          )
        ]));
  }
}
