import 'dart:async';
import 'dart:developer';
import 'package:first_app/layout/customerAppBar.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';

class DriverMap2 extends StatefulWidget {
  DriverMap2({Key? key}) : super(key: key);

  @override
  _DriverMap2 createState() => _DriverMap2();
}

class _DriverMap2 extends State<DriverMap2> {
  //late PageController controller;
  //late int indexPage;

  //LatLng locAwal = LatLng(-7.860693, 112.684099);
  //LatLng locTujuan = LatLng(-7.862997, 112.683992);
  Location location = Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;

  @override
  void initState() {
    super.initState();
    getLocSekarang();
    dewa();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  void dewa() async {
    var response = await http.get(Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/13.388860,52.517037;13.397634,52.529407;13.428555,52.523219?overview=false'));
    log("$response");
  }

  void getLocSekarang() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((currentLocation) {
      setState(() {
        _error = null;

        _location = currentLocation;
      });
    });
    setState(() {});
  }

  Future<void> _stopListen() async {
    await _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  void selesaiKirim(id, idcart) async {
    await supabase.from('transaction').update({
      "statusdriver": "selesai",
      "status": "selesai",
    }).eq('id', id);

    for (var idcartz in idcart) {
      await supabase
          .from('cart')
          .update({'status': 'selesai'}).match({'id': idcartz});
    }

    Fluttertoast.showToast(
      backgroundColor: Colors.green,
      textColor: Colors.white,
      msg: 'Pengirim sudah selesai',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    log("${arg["shopLat"]}");

    LatLng locAwal =
        LatLng(double.parse(arg["shopLat"]), double.parse(arg["shopLon"]));
    LatLng locTujuan =
        LatLng(double.parse(arg["custLat"]), double.parse(arg["custLon"]));
    var shopDat = arg["shopDat"][0];
    var tid = arg["tid"];
    var idcart = arg["idcart"];
    var dat1 = arg["shopDat"];
    var dat2 = arg["custDat"];
    return Scaffold(
        appBar: LayoutCustomerAppBar(
            title: Text("Kirim Ke Customer",
                style: const TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        body: _location == null
            ? const Center(child: Text("Loading"))
            : Container(
                color: Colors.white,
                child: Stack(children: [
                  Container(
                    margin: const EdgeInsets.all(0),
                    height: screenSize.height,
                    child: FlutterMap(
                      options: MapOptions(
                        center:
                            LatLng(_location!.latitude!, _location!.longitude!),
                        zoom: 19,
                        maxZoom: 19,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                          maxZoom: 19,
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: LatLng(
                                  _location!.latitude!, _location!.longitude!),
                              anchorPos: AnchorPos.align(AnchorAlign.top),
                              builder: (ctx) => const Icon(
                                Icons.pedal_bike,
                                color: Colors.green,
                                size: 20.0,
                              ),
                            ),
                          ],
                        ),
                        MarkerLayer(
                          rotate: true,
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: locTujuan,
                              anchorPos: AnchorPos.align(AnchorAlign.top),
                              builder: (ctx) => const Icon(
                                Icons.account_circle,
                                color: Colors.redAccent,
                                size: 20.0,
                              ),
                            ),
                          ],
                        ),
                        /*
                TappablePolylineLayer(
                  // Will only render visible polylines, increasing performance
                  polylineCulling: true,
                  polylines: [
                    TaggedPolyline(
                      tag: "Trajet X", // Trajet Name
                      points: [locAwal, locTujuan],
                      color: Colors.blueGrey,
                      strokeWidth: 5.0, // plot size
                      isDotted: false, // if true id display dotted,
                    ),
                  ],
                ),*/
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: screenSize.height / 4,
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(children: [
                            Text("Nama Toko : ${shopDat['namatoko']}\n",
                                textAlign: TextAlign.center),
                            Text("Alamat : ${shopDat['alamat']}\n",
                                textAlign: TextAlign.center),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: true,
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF2B9EA4),
                                  ),
                                  onPressed: () {
                                    selesaiKirim(tid, idcart);
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, "/driver_home", (r) => false);
                                  },
                                  icon: const Icon(
                                      Icons.production_quantity_limits),
                                  label: const Padding(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text("Diterima Customer",
                                        style: TextStyle(fontSize: 16)),
                                  )),
                            )
                          ]),
                        ),
                      ))
                ])));
  }
}


/*
class SimpleOSM extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useMapController(
        initPosition: GeoPoint(
      latitude: -7.860743,
      longitude: 112.684213,
    ));
    useMapIsReady(
      controller: controller,
      mapIsReady: () async {
        await controller.setZoom(zoomLevel: 15);
      },
    );
    return OSMFlutter(
      controller: controller,
      osmOption: OSMOption(
        markerOption: MarkerOption(
          defaultMarker: MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}
*/