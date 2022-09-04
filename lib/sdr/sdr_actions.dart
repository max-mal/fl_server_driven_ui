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

  static openDialog(Map<String, dynamic> args, SdrBuildWidgetData build) {
    Get.dialog(buildWidget(build.nested(args['child'])));
  }

  static back(Map<String, dynamic> args, SdrBuildWidgetData build) {
    Get.back();
  }

  static closeDialogs(Map<String, dynamic> args, SdrBuildWidgetData build) {
    Get.until((route) => !Get.isDialogOpen!);
  }

  static open(Map<String, dynamic> args, SdrBuildWidgetData build) {
    Get.to(() => buildWidget(build.nested(args['child'])));
  }
}
