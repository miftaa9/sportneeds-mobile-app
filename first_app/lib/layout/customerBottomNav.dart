import 'package:flutter/material.dart';

class LayoutCustomerBottomNav extends StatelessWidget
    implements PreferredSizeWidget {
  //final Text title;

  const LayoutCustomerBottomNav({
    Key? key,
    //required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size(double.infinity, 80);

  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 40,
      selectedIconTheme: IconThemeData(color: Colors.amberAccent, size: 40),
      selectedItemColor: Colors.amberAccent,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
                context, "/customer_home", (r) => false);
            break;
          case 1:
            Navigator.pushNamedAndRemoveUntil(
                context, "/customer_cart", (r) => false);
            break;
          case 2:
            Navigator.pushNamedAndRemoveUntil(
                context, "/customer_profile", (r) => false);
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("asset/images/b/home.png"),
            color: Color(0xFF2B9EA4),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("asset/images/b/pesanan.png"),
            color: Color(0xFF2B9EA4),
          ),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage("asset/images/b/akun.png"),
            color: Color(0xFF2B9EA4),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
