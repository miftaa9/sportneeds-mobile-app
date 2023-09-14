import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:location/location.dart' as locationv2;
import 'package:trust_location/trust_location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  locationv2.Location lokasi = locationv2.Location();
  double _latitude = 0;
  double _longitude = 0;
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocation();
    _redirect();
  }

  Future<bool> requestPermission() async {
    bool serviceEnabled;
    locationv2.PermissionStatus permissionGranted;
    serviceEnabled = await lokasi.serviceEnabled();

    //ceck service
    if (!serviceEnabled) {
      serviceEnabled = await lokasi.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    //ceck permission
    permissionGranted = await lokasi.hasPermission();
    if (permissionGranted == locationv2.PermissionStatus.denied) {
      permissionGranted = await lokasi.requestPermission();
      if (permissionGranted != locationv2.PermissionStatus.granted) {
        return false;
      }
    }

    return true;
  }

  Future<void> getLocation() async {
    final hasPermisson = await requestPermission();
    if (!hasPermisson) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Permission Denied'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const [
                    Text(
                        "Tanpa izin penggunaan lokasi aplikasi ini tidak dapat digunakan",
                        style: TextStyle(fontSize: 18.0)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('SAYA YAKIN'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            );
          });
    } else {
      //get Location
      TrustLocation.start(5);
      try {
        TrustLocation.onChange.listen((values) {
          var mockStatus = values.isMockLocation;
          log("$values");
          TrustLocation.stop();
          _isLoading = false;
        });
      } on PlatformException catch (e) {
        debugPrint('PlatformException $e');
      }
    }
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = supabase.auth.currentSession;
    if (session != null && _isLoading == false) {
      Navigator.pushNamed(context, '/customer_home');
    } else {
      Navigator.pushNamed(context, '/first');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
    );
  }
}
