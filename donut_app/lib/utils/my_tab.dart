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
    return Tab(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            //Borde circular
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: Image.asset(widget.iconPath, color: Colors.grey[600]),
              ),
              Text(widget.iconName, style: TextStyle(fontSize: 8)),
            ],
          ),
        ),
      ),
    );
  }
}
