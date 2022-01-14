import 'package:flutter/material.dart';
import 'package:task/Screen/home.dart';
import 'Widgets/colordata.dart';
import 'Widgets/text.dart';

class BottomBarPage extends StatefulWidget {
  const BottomBarPage({Key? key}) : super(key: key);

  @override
  _BottomBarPageState createState() => _BottomBarPageState();
}

class _BottomBarPageState extends State<BottomBarPage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
   const HomePage(),
    NormalText(
        size: 20,
        color: ColorData.primary,
        text: 'Person',
        weight: FontWeight.w500
    ),
  ];

  void _onItemTapped(int index) {
    //setState(() {
      _selectedIndex = index;
   // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                  color: ColorData.grey,
                ),
                activeIcon: Icon(
                  Icons.home_filled,
                  color: ColorData.primary,
                ),
                label: '',
                backgroundColor: ColorData.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: ColorData.grey,
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: ColorData.primary,
                ),
                label: '',
                backgroundColor: ColorData.white),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
