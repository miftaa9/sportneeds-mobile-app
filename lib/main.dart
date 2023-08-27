import 'package:first_app/customer/cart.dart';
import 'package:first_app/customer/cart_checkout.dart';
import 'package:first_app/customer/nutrishop_addcart.dart';
import 'package:first_app/customer/nutrishop_detail.dart';
import 'package:first_app/partner/driver.dart';
import 'package:first_app/partner/nutrishop_home.dart';
import 'package:first_app/partner/nutrishop_produk.dart';
import 'package:first_app/partner/nutrishop_produk_add.dart';
import 'package:first_app/partner/nutrisionis_chat.dart';
import 'package:first_app/partner/nutrisionis_home.dart';
import 'package:first_app/partner/nutrisionis_profile.dart';
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
        '/customer_shop_detail': (_) => CustomerShopDetail(),
        '/customer_shop_addcart': (_) => CustomerShopAddcart(),
        '/customer_cart': (_) => CustomerCart(),
        '/customer_cart_checkout': (_) => CustomerCartCheckout(),
        '/customer_konsultasi': (_) => CustomerKonsultasi(),
        '/customer_konsultasi_show': (_) => CustomerKonsultasiShow(),
        '/menu_registrasi': (_) => Menu_Registrasi(),
        '/reg_driver': (_) => Regist_Driver(),
        '/reg_nutrishop': (_) => Regist_Nutrishop(),
        '/reg_nutrisionis': (_) => Regist_Nutrisionis(),
        '/nutrisionis_home': (_) => NutrisionisHome(),
        '/nutrisionis_konsultasi_show': (_) => NutrisionisChat(),
        '/nutrisionis_profile': (_) => NutrisionisProfile(),
        '/nutrishop_home': (_) => NutrishopHome(),
        '/nutrishop_produk': (_) => NutrishopProduk(),
        '/nutrishop_produk_add': (_) => NutrishopAdd(),
        '/driver_home': (_) => DriverHome(),
      },
    );
  }
}
