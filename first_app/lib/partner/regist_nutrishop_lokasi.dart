//import 'package:androidflutter/widgets/cache_tile.dart';
import 'dart:developer';

import 'package:first_app/layout/customerAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:location/location.dart' as locationv2;
import 'package:trust_location/trust_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class Regist_Nutrishop_lokasi extends StatefulWidget {
  const Regist_Nutrishop_lokasi({Key? key}) : super(key: key);

  @override
  State<Regist_Nutrishop_lokasi> createState() => _Regist_Nutrishop_lokasi();
}

class _Regist_Nutrishop_lokasi extends State<Regist_Nutrishop_lokasi> {
  locationv2.Location lokasi = locationv2.Location();
  double _latitude = 0;
  double _longitude = 0;
  String? _address;
  bool isLoading = true;
  final MapController _mapController = MapController();

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLocation() async {
    locationv2.LocationData _locationData = await lokasi.getLocation();
    log("dd $_locationData");
    lokasi.onLocationChanged.listen((locationv2.LocationData currentLocation) {
      if (mounted) {
        setState(() {
          isLoading = false;
          _latitude = double.parse(currentLocation.latitude.toString());
          _longitude = double.parse(currentLocation.longitude.toString());

          _mapController.move(LatLng(_latitude, _longitude), 13);

          getPlace();
        });
      }
    });
    /*TrustLocation.start(5);
    try {
      TrustLocation.onChange.listen((values) {
        var mockStatus = values.isMockLocation;

        if (mounted) {
          setState(() {
            isLoading = false;
            _latitude = double.parse(values.latitude.toString());
            _longitude = double.parse(values.longitude.toString());

            _mapController.move(LatLng(_latitude, _longitude), 13);

            getPlace();
          });
        }
      });
    } on PlatformException catch (e) {
      debugPrint('PlatformException $e');
    }*/
  }

  void getPlace() async {
    List<Placemark> newPlace =
        await placemarkFromCoordinates(_latitude, _longitude);

    // this is all you need
    Placemark placeMark = newPlace[0];
    String name = placeMark.name.toString();
    String subLocality = placeMark.subLocality.toString();
    String locality = placeMark.locality.toString();
    String administrativeArea = placeMark.administrativeArea.toString();
    String postalCode = placeMark.postalCode.toString();
    String country = placeMark.country.toString();
    String address =
        "$name, $subLocality, $locality, $administrativeArea $postalCode, $country";

    setState(() {
      _address = address; // update _address
    });
  }

  Widget displayMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(_latitude, _latitude),
        zoom: 15,
        maxZoom: 19,
      ),
      nonRotatedChildren: [
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => {},
            ),
          ],
        ),
      ],
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
          subdomains: ['a', 'b', 'c'],
          maxZoom: 19,
        ),
        MarkerLayer(
          rotate: true,
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(_latitude, _longitude),
              anchorPos: AnchorPos.align(AnchorAlign.top),
              builder: (ctx) => const Icon(
                Icons.fmd_good,
                color: Colors.redAccent,
                size: 20.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: LayoutCustomerAppBar(
            title: Text("Lokasi",
                style: const TextStyle(
                  fontSize: 34,
                  color: Color(0xFF2B9EA4),
                ))),
        body: Container(
            color: Colors.white,
            child: Stack(children: [
              Container(
                margin: const EdgeInsets.all(0),
                height: screenSize.height / 1.5,
                child: displayMap(),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: screenSize.height / 4,
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(children: [
                        Visibility(
                          visible: isLoading ? true : false,
                          child: const CircularProgressIndicator(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        isLoading
                            ? const Text("Sedang mencari lokasi ...")
                            : Text(
                                "Lokasi anda adalah \n: Lat : $_latitude \nLong : $_longitude"),
                        Text("Alamat : \n" + _address.toString(),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: isLoading ? false : true,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF2B9EA4),
                              ),
                              onPressed: () {
                                Navigator.pop(context, [
                                  "$_latitude",
                                  "$_longitude",
                                  "${_address.toString()}"
                                ]);
                              },
                              icon: const Icon(Icons.my_location_outlined),
                              label: const Padding(
                                padding: EdgeInsets.all(15.0),
                                child:
                                    Text("OK", style: TextStyle(fontSize: 16)),
                              )),
                        )
                      ]),
                    ),
                  ))
            ])));
  }
}
