library sdr;

import 'package:cshell/sdr/sdr_actions.dart';
import 'package:cshell/sdr/sdr_builders.dart';
import 'package:cshell/sdr/sdr_transformers.dart';
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
  "sized_box": SdrBuilders.buildSizedBox,
  "alert_dialog": SdrBuilders.buildAlertDialog,
  "text_field": SdrBuilders.buildTextField,
  "icon": SdrBuilders.buildIcon,
  "dropdown_button": SdrBuilders.buildDropDownButton,
  "boolean": SdrBuilders.buildBoolean,
  "ui_container": SdrBuilders.buildUiContainer,
  "ui_hcontainer": SdrBuilders.buildUiHContainer,
  "ui_area": SdrBuilders.buildUiArea,
  "html": SdrBuilders.buildHtml,
};

Map<String, Function(Map<String, dynamic>, SdrBuildWidgetData)> sdrActions = {
  "set_variable": SdrActions.setVariable,
  "increment_variable": SdrActions.incrementVariable,
  "decrement_variable": SdrActions.decrementVariable,
  "sdr_request": SdrActions.sdrRequest,
  "open_dialog": SdrActions.openDialog,
  "open": SdrActions.open,
  "back": SdrActions.back,
  "close_dialogs": SdrActions.closeDialogs,
};

Map<String, Function(Map<String, dynamic>, SdrBuildWidgetData)>
    sdrTransformers = {
  "add": SdrTransformers.addTransformer,
  "substract": SdrTransformers.substractTransformer,
  "and": SdrTransformers.andTransformer,
  "or": SdrTransformers.orTransformer,
  "not": SdrTransformers.notTransformer,
  "eq": SdrTransformers.eqTransformer,
  "gt": SdrTransformers.gtTransformer,
  "gte": SdrTransformers.gteTransformer,
  "lt": SdrTransformers.ltTransformer,
  "lte": SdrTransformers.lteTransformer,
  "join": SdrTransformers.joinTransformer,
  "split": SdrTransformers.splitTransformer,
  "replace": SdrTransformers.replaceTransformer,
  "contains": SdrTransformers.containsTransformer,
  "lowercase": SdrTransformers.lowercaseTransformer,
  "uppercase": SdrTransformers.uppercaseTransformer,
  "trim": SdrTransformers.trimTransformer,
  "filter": SdrTransformers.filterTransformer,
  "pipeline": SdrTransformers.pipelineTransformer,
};

Widget buildWidget(SdrBuildWidgetData build) {
  final data = build.data;
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
    actionsList = List<Map<String, dynamic>>.from(actions);
  }

  for (Map<String, dynamic> action in actionsList) {
    final actionFunction = sdrActions[action['_']];
    if (actionFunction == null) {
      print('Unknown action ${action['_']}');
      print(action);
      continue;
    }
    print('Launching action ${action['_']}');
    final _action = Map<String, dynamic>.from(action);
    for (String key in _action.keys) {
      _action[key] = sdrGetVariable(_action[key], build);
    }
    print(_action);
    actionFunction(_action, build);
  }
}

sdrUpdate(Map<String, dynamic> updateData) {
  Map<String, dynamic> templates = updateData['templates'] ?? {};

  for (String name in templates.keys) {
    sdrTemplatesData[name] = templates[name];
  }

  Map<String, dynamic> areas = updateData['areas'] ?? {};

  for (String areaId in areas.keys) {
    if (!sdrAreaRxVariables.containsKey(areaId)) {
      sdrAreaRxVariables[areaId] = {};
    }

    sdrAreaData[areaId] = SdrBuildWidgetData(
      areaId: areaId,
      data: areas[areaId],
      variables: {},
    );
    sdrAreaWidget[areaId] = buildWidget(sdrAreaData[areaId]!);
  }

  List<dynamic> actions = updateData['actions'] ?? [];

  for (final action in actions) {
    executeActions(
      action,
      SdrBuildWidgetData(
        areaId: action['area'] ?? '_',
        variables: {},
        data: {},
      ),
    );
  }
}

RxMap<String, Widget> sdrAreaWidget = RxMap<String, Widget>();
Map<String, SdrBuildWidgetData> sdrAreaData = {};
Map<String, Map<String, Rx<dynamic>>> sdrAreaRxVariables = {};
Map<String, Map<String, dynamic>> sdrTemplatesData = {};

_sdrGetVariable(dynamic value, SdrBuildWidgetData build,
    {bool isInner = false}) {
  if (value.toString().startsWith('\$\$')) {
    String key = value.toString().substring(2);
    if (sdrAreaRxVariables[build.areaId]?.containsKey(key) == true) {
      return sdrAreaRxVariables[build.areaId]?[key]?.value;
    }
  }

  if (value.toString().startsWith('\$')) {
    String key = value.toString().substring(1);
    if (build.variables.containsKey(key)) {
      return build.variables[key];
    }
  }

  String valueString = value.toString();

  if (!isInner && valueString.startsWith('\$') && valueString.contains('.')) {
    return _sdrGetInnerVariable(value, build);
  }

  return value;
}

_sdrGetInnerVariable(dynamic value, SdrBuildWidgetData build) {
  String valueString = value.toString();

  List<String> parts = valueString.split('.');
  dynamic retValue;
  for (String part in parts) {
    if (part.isEmpty) {
      retValue = retValue.toString() + '.';
      continue;
    }
    dynamic cValue = _sdrGetVariable(part, build, isInner: true);
    if (retValue == null) {
      retValue = cValue;
    } else {
      if (retValue is List || retValue is String) {
        final index = int.parse(cValue.toString());
        if (index >= retValue.length) {
          return null;
        }
        retValue = retValue[int.parse(cValue.toString())];
        continue;
      }

      if (retValue is Map) {
        retValue = retValue[cValue.toString()];
        continue;
      }
    }
  }

  return retValue;
}

_sdrGetVariableInterpolate(dynamic value, SdrBuildWidgetData build) {
  if (value is String && value.contains('\$')) {
    final regEx = RegExp(r'(\$[\$\w.]*)');
    final matches = regEx.allMatches(value);
    for (RegExpMatch match in matches) {
      final group = match.group(1);
      value = value.replaceAll(group, _sdrGetVariable(group, build).toString());
    }
  }
  return value;
}

sdrGetVariable(dynamic value, SdrBuildWidgetData build) {
  if (value == null) {
    return null;
  }

  if (value is Map<String, dynamic> && value['_v'] == 'transform') {
    final transformerName = sdrGetVariable(value['_'], build);
    final transformerFn = sdrTransformers[transformerName];

    if (transformerFn == null) {
      print("Unknown transformer: $transformerName");
      return null;
    }

    return transformerFn(value, build);
  }

  if (value is Map && value['_v'] == 'raw') {
    return value['value'];
  }

  if (value is Map && value['_v'] == 'interpolate') {
    return _sdrGetVariableInterpolate(value['value'], build);
  }

  if (value is Map && value['_v'] != null) {
    return _sdrGetVariable(value['_v'], build);
  }

  return value;
}

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
      variables: Map<String, dynamic>.from(variables),
    );
  }
}
