import 'package:flutter/material.dart';

class MyTab extends StatefulWidget {
  final String iconPath;
  final String iconName;
  const MyTab({super.key, required this.iconPath, required this.iconName});

  @override
  State<MyTab> createState() => _MyTabState();
}

class _MyTabState extends State<MyTab> {
  @override
  Widget build(BuildContext context) {
    return Tab();
  }
}
