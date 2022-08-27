import 'package:cshell/sdr/sdr.dart';

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
}
