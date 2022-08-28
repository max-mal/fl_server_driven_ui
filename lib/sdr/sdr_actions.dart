import 'package:cshell/controllers/app.dart';
import 'package:cshell/sdr/sdr.dart';
import 'package:get/get.dart';

class SdrActions {
  static setVariable(Map<String, dynamic> args, SdrBuildWidgetData build) {
    final areaMap = sdrAreaRxVariables[build.areaId]!;
    final variableRx = areaMap[args['name']!]!;
    variableRx(args['value']);
  }

  static incrementVariable(
      Map<String, dynamic> args, SdrBuildWidgetData build) {
    final areaMap = sdrAreaRxVariables[build.areaId]!;
    final variableRx = areaMap[args['name']!]!;
    variableRx(variableRx.value + (args['value'] ?? 1));
  }

  static decrementVariable(
      Map<String, dynamic> args, SdrBuildWidgetData build) {
    final areaMap = sdrAreaRxVariables[build.areaId]!;
    final variableRx = areaMap[args['name']!]!;
    variableRx(variableRx.value - (args['value'] ?? 1));
  }

  static sdrRequest(Map<String, dynamic> args, SdrBuildWidgetData build) {
    final controller = Get.find<AppController>();
    controller.doSdrRequest(args);
  }
}
