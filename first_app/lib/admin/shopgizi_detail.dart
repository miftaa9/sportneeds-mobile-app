import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:first_app/main.dart';
import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';

class adminShopGiziDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _adminShopGiziDetail();
  }
}

class _adminShopGiziDetail extends State<adminShopGiziDetail> {
  onGoBack(dynamic value) {
    setState(() {
      _adminShopGiziDetail();
    });
  }

  var ab = [
    'Energy',
    'Water',
    'Protein',
    'Fat',
    'Carbohydr',
    'Dietary',
    'Alcohol',
    'PUFA',
    'Cholesterol',
    'Vit. A',
    'Carotene',
    'Vit. E',
    'Vit. B1',
    'Vit. B2',
    'Vit. B6',
    'Tot. Fol.Acid',
    'Vit. C',
    'Sodium',
    'Potassium',
    'Calcium',
    'Magnesium',
    'Phosphorus',
    'Iron',
    'Zinc',
  ];

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
          title: Text('Data Gizi-Shop (${namatoko})',
              style: TextStyle(
                fontSize: 18,
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
                                  '/admin_gizishop_cu',
                                  arguments: country,
                                ).then(onGoBack);
                              },
                              icon: const Icon(Icons.edit),
                              color: Color(0xFF2B9EA4)),
                        ],
                      ),
                    ),
                    Accordion(
                        headerBorderColor: Color(0xFF2B9EA4),
                        headerBorderColorOpened: Color(0xFF2B9EA4),
                        // headerBorderWidth: 1,
                        contentBackgroundColor: Colors.white,
                        contentBorderColor: Color(0xFF2B9EA4),
                        contentBorderWidth: 3,
                        contentHorizontalPadding: 20,
                        scaleWhenAnimating: true,
                        openAndCloseAnimation: true,
                        headerPadding: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        sectionOpeningHapticFeedback:
                            SectionHapticFeedback.heavy,
                        sectionClosingHapticFeedback:
                            SectionHapticFeedback.light,
                        children: [
                          AccordionSection(
                            isOpen: false,
                            headerBackgroundColor: Color(0xFF2B9EA4),
                            header: RichText(
                              text: const TextSpan(
                                text: 'Kandungan ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Gizi',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            content: DataTable(
                              sortAscending: true,
                              sortColumnIndex: 1,
                              showBottomBorder: false,
                              columns: const [
                                DataColumn(
                                    label: Text('No',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                          fontSize: 10,
                                        )),
                                    numeric: true),
                                DataColumn(
                                    label: Text('Nama',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                          fontSize: 10,
                                        ))),
                                DataColumn(
                                    label: Text('Nilai',
                                        style: TextStyle(
                                          color: Color(0xFF2B9EA4),
                                          fontSize: 10,
                                        )),
                                    numeric: true),
                              ],
                              rows: [
                                ...ab.asMap().keys.toList().map((i) {
                                  var ccz = country['a' + (i + 1).toString()];
                                  var cc =
                                      (ccz == null || ccz.isEmpty) ? '' : ccz;
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((i + 1).toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 10,
                                          ))),
                                      DataCell(Text(ab[i],
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 10,
                                          ))),
                                      DataCell(Text('${cc}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 10,
                                          )))
                                    ],
                                  );
                                })
                              ],
                            ),
                          ),
                        ]),
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
