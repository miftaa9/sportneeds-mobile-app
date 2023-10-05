import 'dart:convert';
import 'dart:developer';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/layout/customerBottomNav.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:first_app/main.dart';
import 'package:flutter/services.dart';

class KaloriT {
  KaloriT({
    required this.id,
    required this.user_id,
    required this.kalori_data_id,
    required this.energi,
    required this.tgl,
    required this.jumlah,
  });

  final int id;

  final user_id;
  final kalori_data_id;
  final energi;
  final tgl;
  final jumlah;

  KaloriT.fromMap({
    required Map<String, dynamic> map,
  })  : id = map['id'],
        user_id = map['user_id'],
        kalori_data_id = map['kalori_data_id'],
        energi = map['energi'],
        tgl = map['tgl'],
        jumlah = map['jumlah'];
}

class CustomerKalori extends StatefulWidget {
  const CustomerKalori({
    Key? key,
  }) : super(key: key);
  @override
  State<CustomerKalori> createState() => _CustomerKalori();
}

class _CustomerKalori extends State<CustomerKalori> {
  // Initial Selected Value
  TextEditingController jumlah = TextEditingController();
  var dropdownvalue = null;
  var val2;

  // List of items in our dropdown menu
  var items = ['Item 1', 'Item 4', 'Item 2'];
  var items1 = [];
  var items2 = [];

  Future dataDropdown() async {
    await Future.delayed(Duration.zero);
    final _future = await supabase.from('kalori_data').select();
    var itemas = [];
    var itemas2 = [];

    for (var x in _future) {
      log("rt ${x['nama']}");
      var a = "'${x['nama']}'";
      itemas.add(a);
      //itemas2.add({x['id']: x['energi']});
      itemas2[x['id']] = x['energi'];
    }
    _future.map((v) {});

    log("y ${itemas2}");
    setState(() {
      items1 = itemas;
      items2 = itemas2;
    });
    log("ev $items1");
  }

  Future processSimpan(id) async {
    log("r $dropdownvalue");
    log("t ${jumlah.text}");
    log("y ${items2}");
    items2.map((entry) {
      log("y ${entry}");
    });

    final dtkalori = await supabase
        .from('cabang_olahraga_aktifitas')
        .select()
        .eq('id', dropdownvalue)
        .single();

    String date1 = DateFormat("yyyy-MM-dd").format(DateTime.now());
    double totenergi = (double.parse(jumlah.text) / 60) * dtkalori['energi'];
    String totenergiz = totenergi.toStringAsFixed(2);

    await supabase.from('kalori').insert({
      "user_id": id,
      "kalori_data_id": dropdownvalue,
      "kalori_data_nama": dtkalori['nama'],
      "tgl": date1,
      "jumlah": jumlah.text,
      "energi": totenergiz,
    });
    Fluttertoast.showToast(
      msg: 'Profile sukses di-update',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    log("dewa2");
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    final int uid = arg["user_id"];
    final int cbid = arg["cabang_id"];
    print("z ${cbid}");
    final _futurex = supabase
        .from('cabang_olahraga_aktifitas')
        .select()
        .eq('cabora_id', cbid);

    DateTime _selectedValue = DateTime.now();
    String dateO = DateFormat("yyyy-MM-dd").format(_selectedValue);
    log("$dateO");
    final _futurex2 = supabase
        .from('kalori')
        .select()
        .eq('user_id', uid)
        .eq('tgl', dateO)
        .order('id', ascending: true);

    return Scaffold(
        backgroundColor: Color(0xFF2B9EA4),
        appBar: const LayoutCustomerAppBar(
            title: Text('Kalori Harian',
                style: TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        bottomNavigationBar: LayoutCustomerBottomNav(),
        body: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(children: <Widget>[
                  Expanded(
                      child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
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
                                          log("zz ${dat}");

                                          if (dat != null) {
                                            return Container(
                                              width: 260,
                                              height: 60,
                                              child: DropdownButton(
                                                isExpanded: true,
                                                iconEnabledColor:
                                                    Color(0xFF2B9EA4),
                                                underline: Container(
                                                  width: 200,
                                                  height: 1,
                                                  color: Color(0xFF2B9EA4),
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
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: (fc['id']
                                                              .toString()),
                                                          child:
                                                              Text(fc['nama']),
                                                        ))
                                                    .toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    dropdownvalue = newValue!;
                                                  });
                                                },
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        }),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      width: 260,
                                      height: 60,
                                      child: TextField(
                                        controller: jumlah,
                                        //controller: namaController,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        style:
                                            TextStyle(color: Color(0xFF2B9EA4)),
                                        decoration: InputDecoration(
                                          labelText: "Durasi Latihan (Menit)",
                                          labelStyle: TextStyle(
                                              color: Color(0xFF2B9EA4)),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF2B9EA4)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFF2B9EA4)),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        processSimpan(uid);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(top: 10.0),
                                        alignment: Alignment.center,
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          color: Color(0xFF2B9EA4),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            processSimpan(uid);
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.all(12.0),
                                            minimumSize: Size(50, 30),
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          child: Text(
                                            'Tambah',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    ListTile(
                                      leading: const Text(
                                        '#',
                                        style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      title: const Text(
                                        'Nama Aktifitas',
                                        style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: const Text(
                                        '%',
                                        style: TextStyle(
                                            color: Color(0xFF2B9EA4),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    FutureBuilder(
                                        future: _futurex2,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          final datz = snapshot.data!;
                                          log("ew $datz");
                                          //return Text('');
                                          return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: datz.length,
                                              itemBuilder: (context, index) {
                                                final dazz = datz[index];
                                                return ListTile(
                                                  visualDensity: VisualDensity(
                                                      horizontal: 0,
                                                      vertical: -4),
                                                  dense: true,
                                                  leading: Text(
                                                    "${index + 1}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  title: Text(
                                                    "${dazz['kalori_data_nama']}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  onTap: () {},
                                                  trailing: Text(
                                                    "${dazz['energi']} kkal",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                );
                                              });
                                          /*var a = datz.map((maps) => maps
                                                    .map((map) =>
                                                        KaloriT.fromMap(
                                                            map: map))
                                                    .toList());*/
                                        }),
                                    FutureBuilder(
                                        future: _futurex2,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                          final yat = snapshot.data!;
                                          double totalenergiz = 0.0;
                                          int no = 0;
                                          log("vv $yat");
                                          return ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: yat.length,
                                              itemBuilder: (context, index) {
                                                final yatz = yat[index];
                                                totalenergiz += double.parse(
                                                    yatz['energi']);
                                                no += 1;
                                                log("km $no $index ${yat.length}");
                                                return (index ==
                                                        (yat.length - 1))
                                                    ? ListTile(
                                                        leading: Text(
                                                          '',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF2B9EA4),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        title: Text(
                                                          'Total',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF2B9EA4),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        trailing: Text(
                                                          '${totalenergiz.toStringAsFixed(2)}  kkal',
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF2B9EA4),
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : Text('');
                                              });
                                        }),
                                  ])))),
                ]))));
  }
}
