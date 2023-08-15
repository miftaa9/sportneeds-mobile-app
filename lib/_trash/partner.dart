import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:first_app/customer/login.dart';
import 'package:first_app/partner/menu_registrasi.dart';

class Partner extends StatelessWidget {
  void click() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 10.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          /*decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Colors.purpleAccent,
                Colors.amber,
                Colors.blue,
              ])),*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 10.0, top: 40),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(
                          Color(0xFF2B9EA4)), // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return Color.fromARGB(
                              255, 34, 125, 129); // <-- Splash color
                      }),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 150,
                        child: Image.asset('asset/images/logopartner.png',
                            width: 100.0, height: 100.0)),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 325,
                height: 410,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B9EA4),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      alignment: Alignment.center,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Nutrisionist',
                            style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      alignment: Alignment.center,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Nutrishop',
                            style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      alignment: Alignment.center,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Driver',
                            style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Belum punya akun?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 250,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Menu_Registrasi(),
                          ));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Register',
                            style: TextStyle(
                                color: Color(0xFF2B9EA4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
