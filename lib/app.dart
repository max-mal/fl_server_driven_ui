import 'package:cshell/controllers/app.dart';
import 'package:cshell/main.dart';
import 'package:cshell/sdr/sdr_area.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final controller = Get.put(AppController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SdrArea(areaId: 'menu'),
            controller.error.value != null
                ? Expanded(
                    child: Center(
                      child: Text(controller.error.value ?? ''),
                    ),
                  )
                : const Expanded(
                    child: SdrArea(
                      areaId: 'main',
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => controller.initializeMenu(),
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: () => Get.to(() => const TestAreaWidget()),
                  icon: const Icon(Icons.bug_report),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
