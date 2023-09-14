import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:first_app/main.dart';

class CustomerShopDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CustomerShopDetail();
  }
}

class _CustomerShopDetail extends State<CustomerShopDetail> {
  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final int uid = arg["user_id"];
    final String namatoko = arg["namatoko"];
    final _future = supabase
        .from('nutrishop_produk')
        .select<List<Map<String, dynamic>>>()
        .eq('user_id', uid);
    return Scaffold(
      backgroundColor: Color(0xFF2B9EA4),
      appBar: LayoutCustomerAppBar(
          title: Text(namatoko,
              style: const TextStyle(
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
              final tesjpg = supabase.storage
                  .from('shop_produk')
                  .getPublicUrl(country['img']);
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Image.network(tesjpg),
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
                      subtitle: Text("Harga : ${country['harga']}"),
                      onTap: () {},
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/customer_shop_addcart',
                                  arguments: {
                                    'user_id': uid,
                                    'produk_id': country['id'],
                                    'data': country,
                                    'namatoko': namatoko,
                                  },
                                );
                              },
                              icon: const Icon(Icons.add_shopping_cart),
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
    );
  }
}
