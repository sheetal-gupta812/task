import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:task/bottombarpage.dart';
import 'package:task/statemangement/dashboard_screen_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BottomBarPage()),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<DashBoardScreenProvider>(create: (_) => DashBoardScreenProvider()),
  ChangeNotifierProvider<AddProductProvider>(create: (_) => AddProductProvider()),
];


