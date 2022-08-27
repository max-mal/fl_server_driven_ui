library sdr;

import 'package:cshell/sdr/sdr_actions.dart';
import 'package:cshell/sdr/sdr_builders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Map<String, Widget Function(SdrBuildWidgetData)> sdrBuilders = {
  "text": SdrBuilders.buildText,
  "container": SdrBuilders.buildContainer,
  "column": SdrBuilders.buildColumn,
  "padding": SdrBuilders.buildPadding,
  "button": SdrBuilders.buildButton,
};

Map<String, Function(Map<String, dynamic>, SdrBuildWidgetData)> sdrActions = {
  "set_variable": SdrActions.setVariable,
  "increment_variable": SdrActions.incrementVariable,
  "decrement_variable": SdrActions.decrementVariable,
};

Widget buildWidget(SdrBuildWidgetData build) {
  final data = build.data;
  String type = data['type'];
  bool isReactive = false;
  if (type.startsWith('\$')) {
    isReactive = true;
    type = type.substring(1);
  }

  final builderFunction = sdrBuilders[type];
  if (builderFunction == null) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('Unknow Widget type: $type'),
    );
  }

  if (isReactive) {
    return Obx(() => builderFunction(build));
  }

  return builderFunction(build);
}

executeActions(dynamic actions, SdrBuildWidgetData build) {
  if (actions == null) {
    return;
  }
  final List<Map<String, dynamic>> actionsList;
  if (actions is Map<String, dynamic>) {
    actionsList = [actions];
  } else {
    actionsList = actions;
  }

  for (Map<String, dynamic> action in actionsList) {
    final actionFunction = sdrActions[action['_']];
    if (actionFunction == null) {
      print('Unknown action ${action['_']}');
      continue;
    }
    actionFunction(action, build);
  }
}

RxMap<String, Widget> sdrAreaWidget = RxMap<String, Widget>();
Map<String, Map<String, Rx<dynamic>>> sdrAreaRxVariables = {};

class SdrBuildWidgetData {
  Map<String, dynamic> data;
  Map<String, dynamic> variables;
  String areaId;

  SdrBuildWidgetData({
    required this.areaId,
    required this.data,
    required this.variables,
  }) {
    if (data['\$'] != null) {
      variables.addAll(data['\$']);
    }

    if (data['\$\$'] != null) {
      for (String key in data['\$\$'].keys) {
        sdrAreaRxVariables[areaId]![key] = Rx<dynamic>(data['\$\$'][key]);
      }
    }
  }

  SdrBuildWidgetData nested(Map<String, dynamic> nestedData) {
    return SdrBuildWidgetData(
      areaId: areaId,
      data: nestedData,
      variables: variables,
    );
  }
}
