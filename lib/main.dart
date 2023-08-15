import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:first_app/splash.dart';
import 'package:first_app/first.dart';
import 'package:first_app/customer/login.dart';
import 'package:first_app/customer/register.dart';
import 'package:first_app/customer/home.dart';
import 'package:first_app/customer/edukasi.dart';
import 'package:first_app/customer/edukasi_show.dart';
import 'package:first_app/customer/nutrishop.dart';
import 'package:first_app/customer/konsultasi.dart';
import 'package:first_app/customer/konsultasi_show.dart';
import 'package:first_app/partner/menu_registrasi.dart';
import 'package:first_app/partner/regist_driver.dart';
import 'package:first_app/partner/regist_nutrishop.dart';
import 'package:first_app/partner/regist_nutrisionis.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://oyuhagbopgidvyzoqciv.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im95dWhhZ2JvcGdpZHZ5em9xY2l2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTE5MTI5NTQsImV4cCI6MjAwNzQ4ODk1NH0.CrCpL7ZsohoLoVPMGcIhaLljJGkWa6zpXMd1ilh1coE',
    authFlowType: AuthFlowType.pkce,
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        // Splash page is needed to ensure that authentication and page loading works correctly
        '/': (_) => const SplashPage(),
        '/first': (_) => First(),
        '/login': (_) => Login(),
        '/customer_reg': (_) => Customer_Register(),
        '/customer_home': (_) => Customer_Home(),
        '/customer_edukasi': (_) => CustomerEdukasi(),
        '/customer_edukasi_show': (_) => CustomerEdukasiShow(),
        '/customer_shop': (_) => CustomerShop(),
        '/customer_konsultasi': (_) => CustomerKonsultasi(),
        '/customer_konsultasi_show': (_) => CustomerKonsultasiShow(),
        '/menu_registrasi': (_) => Menu_Registrasi(),
        '/reg_driver': (_) => Regist_Driver(),
        '/reg_nutrishop': (_) => Regist_Nutrishop(),
        '/reg_nutrisionis': (_) => Regist_Nutrisionis(),
      },
    );
  }
}
