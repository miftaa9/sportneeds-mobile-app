import 'package:flutter/material.dart';

class LayoutCustomerAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Text title;

  const LayoutCustomerAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 80);

  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: Colors.white,
      elevation: 0.0, //No shadow
      /*actions: [
          Icon(Icons.keyboard_arrow_down),
        ],*/
      actionsIconTheme: IconThemeData(color: Color(0xFF2B9EA4), size: 36),
      toolbarHeight: 80, // default is 56
      leading: Container(
        margin: const EdgeInsets.only(left: 10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(CircleBorder()),
            padding: MaterialStateProperty.all(EdgeInsets.all(2)),
            backgroundColor: MaterialStateProperty.all(
                Color(0xFF2B9EA4)), // <-- Button color
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed))
                return Color.fromARGB(255, 34, 125, 129); // <-- Splash color
            }),
          ),
        ),
      ),
    );
  }
}
