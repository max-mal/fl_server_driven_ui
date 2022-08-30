library sdr;

import 'package:cshell/sdr/sdr_actions.dart';
import 'package:cshell/sdr/sdr_builders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Map<String, Widget Function(SdrBuildWidgetData)> sdrBuilders = {
  "text": SdrBuilders.buildText,
  "container": SdrBuilders.buildContainer,
  "column": SdrBuilders.buildColumn,
  "row": SdrBuilders.buildRow,
  "padding": SdrBuilders.buildPadding,
  "button": SdrBuilders.buildButton,
  "scroll": SdrBuilders.buildScrollView,
  "inkwell": SdrBuilders.buildInkWell,
  "wrap": SdrBuilders.buildWrap,
  "expanded": SdrBuilders.buildExpanded,
  "sdr_area": SdrBuilders.buildSdrArea,
  "center": SdrBuilders.buildCenter,
  "vertical_divider": SdrBuilders.buildVerticalDivider,
  "divider": SdrBuilders.buildDivider,
  "image": SdrBuilders.buildImage,
  "audio_player": SdrBuilders.buildAudioPlayer,
  "list_builder": SdrBuilders.buildListBuilder,
};

Map<String, Function(Map<String, dynamic>, SdrBuildWidgetData)> sdrActions = {
  "set_variable": SdrActions.setVariable,
  "increment_variable": SdrActions.incrementVariable,
  "decrement_variable": SdrActions.decrementVariable,
  "sdr_request": SdrActions.sdrRequest,
};

Widget buildWidget(SdrBuildWidgetData build) {
  final data = build.data;
  print('build: ${build.areaId}');
  String? type = data['type'];

  if (type == null) {
    return const SizedBox();
  }

  bool isReactive = false;
  if (type.startsWith('\$')) {
    isReactive = true;
    type = type.substring(1);
  }

  final templateData = sdrTemplatesData[type];
  if (templateData != null) {
    build.data = templateData;
    return buildWidget(build);
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
      print(action);
      continue;
    }
    actionFunction(action, build);
  }
}

sdrUpdate(Map<String, dynamic> updateData) {
  Map<String, dynamic> templates = updateData['templates'];

  for (String name in templates.keys) {
    sdrTemplatesData[name] = templates[name];
  }

  Map<String, dynamic> areas = updateData['areas'];

  for (String areaId in areas.keys) {
    sdrAreaData[areaId] = SdrBuildWidgetData(
      areaId: areaId,
      data: areas[areaId],
      variables: {},
    );
    sdrAreaWidget[areaId] = buildWidget(sdrAreaData[areaId]!);
  }
  // sdrAreaWidget.refresh();

  // for (String key in sdrAreaWidget.keys) {
  //   sdrAreaWidget[key] = buildWidget(sdrAreaData[key]!);
  // }
  // print('sdrUpdate completed');
}

RxMap<String, Widget> sdrAreaWidget = RxMap<String, Widget>();
Map<String, SdrBuildWidgetData> sdrAreaData = {};
Map<String, Map<String, Rx<dynamic>>> sdrAreaRxVariables = {};
Map<String, Map<String, dynamic>> sdrTemplatesData = {};

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
