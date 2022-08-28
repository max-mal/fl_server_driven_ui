import 'package:cshell/controllers/app.dart';
import 'package:cshell/sdr/sdr_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidget extends StatefulWidget {
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final controller = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          SdrArea(areaId: 'menu'),
          Expanded(
            child: SdrArea(
              areaId: 'main',
            ),
          ),
        ],
      ),
    );
  }
}
