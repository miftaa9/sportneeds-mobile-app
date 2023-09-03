import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';

class DriverHome extends StatefulWidget {
  DriverHome({Key? key}) : super(key: key);

  @override
  _DriverHome createState() => _DriverHome();
}

class _DriverHome extends State<DriverHome> {
  //late PageController controller;
  //late int indexPage;

  LatLng locAwal = LatLng(-7.860693, 112.684099);
  LatLng locTujuan = LatLng(-7.862997, 112.683992);
  Location location = Location();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;

  @override
  void initState() {
    super.initState();
    //controller = PageController(initialPage: 1);
    //indexPage = controller.initialPage;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(children: [
          Text("d",
              style: TextStyle(
                color: Color(0xFF2B9EA4),
                fontSize: 30,
              )),
          Text("d",
              style: TextStyle(
                color: Color(0xFF2B9EA4),
              )),
        ]),
        leading: const Icon(
          Icons.account_circle,
          size: 50,
          color: Color(0xFF2B9EA4),
        ),
        backgroundColor: Colors.white, //You can make this transparent
        elevation: 0.0, //No shadow
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Color(0xFF2B9EA4),
            ),
            onPressed: () {
              Navigator.pushNamed(context, "/driver_tes");
            },
          )
        ],
        actionsIconTheme: IconThemeData(color: Color(0xFF2B9EA4), size: 36),
        toolbarHeight: 80, // default is 56
      ),
      body: _location == null
          ? const Center(child: Text("Loading"))
          : FlutterMap(
              options: MapOptions(
                center: LatLng(_location!.latitude!, _location!.longitude!),
                zoom: 19,
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxZoom: 19,
                ),
                MarkerLayer(
                  rotate: true,
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point:
                          LatLng(_location!.latitude!, _location!.longitude!),
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
                      point: locAwal,
                      anchorPos: AnchorPos.align(AnchorAlign.top),
                      builder: (ctx) => const Icon(
                        Icons.fmd_good,
                        color: Colors.redAccent,
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
                        Icons.home,
                        color: Colors.blue,
                        size: 20.0,
                      ),
                    ),
                  ],
                ),
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
                ),
              ],
            ),
    );
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