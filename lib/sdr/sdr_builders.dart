import 'dart:io';

import 'package:cshell/sdr/sdr.dart';
import 'package:cshell/sdr/sdr_area.dart';
import 'package:cshell/widgets/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:cshell/extensions/color.dart';
import 'package:get/get.dart';

class SdrBuilders {
  static _v(dynamic value, SdrBuildWidgetData build) {
    if (value == null) {
      return null;
    }

    String valueString = value.toString();

    if (valueString.startsWith('\$') && valueString.contains('.')) {
      List<String> parts = valueString.split('.');
      dynamic retValue;
      for (String part in parts) {
        if (part.isEmpty) {
          retValue = retValue.toString() + '.';
          continue;
        }
        dynamic cValue = _v(part, build);
        if (retValue == null) {
          retValue = cValue;
        } else {
          if (retValue is List || retValue is String) {
            retValue = retValue[int.parse(cValue.toString())];
          }

          if (retValue is Map) {
            retValue = retValue[cValue.toString()];
          }
        }
      }

      return retValue;
    }

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

    if (value is String && value.contains('\$')) {
      final regEx = RegExp(r'(\$[\w.]*)');
      final matches = regEx.allMatches(value);
      for (RegExpMatch match in matches) {
        final group = match.group(1);
        value = value.replaceAll(group, _v(group, build).toString());
      }
    }
    return value;
  }

  static TextStyle? _getTextStyle(
      Map<String, dynamic>? data, SdrBuildWidgetData build) {
    if (data == null) {
      return null;
    }

    return TextStyle(
      color: data['color'] != null
          ? HexColor.fromHex(_v(data['color'], build))
          : null,
      fontSize: data['fontSize'] == null
          ? null
          : double.tryParse(_v(data['fontSize'], build).toString()),
    );
  }

  static Widget buildText(SdrBuildWidgetData build) {
    final data = build.data;
    return Text(
      _v(data['text'], build).toString(),
      style: _getTextStyle(data, build),
      textAlign: _getTextAlign(_v(data['textAlign'], build)),
    );
  }

  static TextAlign? _getTextAlign(String? textAlign) {
    if (textAlign == null) {
      return null;
    }
    switch (textAlign) {
      case "center":
        return TextAlign.center;
      case "left":
        return TextAlign.left;
      case "right":
        return TextAlign.right;
      case "justify":
        return TextAlign.justify;
      default:
        return null;
    }
  }

  static Widget buildContainer(SdrBuildWidgetData build) {
    final data = build.data;
    return Container(
      width: _v(data['width'], build),
      height: _v(data['height'], build),
      padding: _getEdgeInsets(_v(data['padding'], build)),
      margin: _getEdgeInsets(_v(data['margin'], build)),
      decoration: BoxDecoration(
        color: data['color'] == null
            ? null
            : HexColor.fromHex(_v(data['color'], build)),
        shape: _v(data['shape'], build) == 'circle'
            ? BoxShape.circle
            : BoxShape.rectangle,
        border: _getContainerBorder(_v(data['border'], build)),
      ),
      child: data['child'] == null
          ? null
          : buildWidget(build.nested(_v(data['child'], build))),
    );
  }

  static EdgeInsets _getEdgeInsets(dynamic data) {
    if (data is Map<String, dynamic>) {
      return EdgeInsets.only(
        top: double.tryParse(data['top'].toString()) ?? 0.0,
        bottom: double.tryParse(data['bottom'].toString()) ?? 0.0,
        left: double.tryParse(data['left'].toString()) ?? 0.0,
        right: double.tryParse(data['right'].toString()) ?? 0.0,
      );
    }

    if (data == null) {
      return EdgeInsets.zero;
    }

    return EdgeInsets.all(double.tryParse(data.toString()) ?? 0);
  }

  static BoxBorder? _getContainerBorder(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    if (data['all'] != null) {
      return Border.all(
        color: HexColor.fromHex(data['all']['color'] ?? '#000000'),
        width: double.tryParse((data['all']['width'] ?? "1").toString()) ?? 1.0,
      );
    }

    return Border(
      top: data['top'] == null
          ? BorderSide.none
          : BorderSide(
              color: HexColor.fromHex(data['top']['color'] ?? '#000000'),
              width:
                  double.tryParse((data['top']['width'] ?? "1").toString()) ??
                      1.0,
            ),
      bottom: data['bottom'] == null
          ? BorderSide.none
          : BorderSide(
              color: HexColor.fromHex(data['bottom']['color'] ?? '#000000'),
              width: double.tryParse(
                      (data['bottom']['width'] ?? "1").toString()) ??
                  1.0,
            ),
      right: data['right'] == null
          ? BorderSide.none
          : BorderSide(
              color: HexColor.fromHex(data['right']['color'] ?? '#000000'),
              width:
                  double.tryParse((data['right']['width'] ?? "1").toString()) ??
                      1.0,
            ),
      left: data['left'] == null
          ? BorderSide.none
          : BorderSide(
              color: HexColor.fromHex(data['left']['color'] ?? '#000000'),
              width:
                  double.tryParse((data['left']['width'] ?? "1").toString()) ??
                      1.0,
            ),
    );
  }

  static Widget buildColumn(SdrBuildWidgetData build) {
    final data = build.data;
    final List<dynamic> children = _v(data['children'], build);
    return Column(
      mainAxisSize: _v(data['size'], build) == 'min'
          ? MainAxisSize.min
          : MainAxisSize.max,
      children: children.map((e) => buildWidget(build.nested(e))).toList(),
      mainAxisAlignment:
          _getMainAxisAlignment(_v(data['mainAxisAlignment'], build)),
      crossAxisAlignment:
          _getCrossAxisAlignment(_v(data['crossAxisAlignment'], build)),
    );
  }

  static Widget buildRow(SdrBuildWidgetData build) {
    final data = build.data;
    final List<dynamic> children = _v(data['children'], build);
    return Row(
      mainAxisSize: _v(data['size'], build) == 'min'
          ? MainAxisSize.min
          : MainAxisSize.max,
      children: children.map((e) => buildWidget(build.nested(e))).toList(),
      mainAxisAlignment:
          _getMainAxisAlignment(_v(data['mainAxisAlignment'], build)),
      crossAxisAlignment:
          _getCrossAxisAlignment(_v(data['crossAxisAlignment'], build)),
    );
  }

  static MainAxisAlignment _getMainAxisAlignment(String? alignment) {
    switch (alignment) {
      case "end":
        return MainAxisAlignment.end;
      case "center":
        return MainAxisAlignment.center;
      case "space_around":
        return MainAxisAlignment.spaceAround;
      case "space_between":
        return MainAxisAlignment.spaceBetween;
      case "space_evently":
        return MainAxisAlignment.spaceEvenly;
      default:
        return MainAxisAlignment.start;
    }
  }

  static CrossAxisAlignment _getCrossAxisAlignment(String? alignment) {
    switch (alignment) {
      case "end":
        return CrossAxisAlignment.end;
      case "center":
        return CrossAxisAlignment.center;
      case "baseline":
        return CrossAxisAlignment.baseline;
      case "stretch":
        return CrossAxisAlignment.stretch;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static Widget buildPadding(SdrBuildWidgetData build) {
    final data = build.data;
    return Padding(
      padding: _getEdgeInsets(_v(data['padding'], build)),
      child: data['child'] == null
          ? null
          : buildWidget(
              build.nested(_v(data['child'], build)),
            ),
    );
  }

  static Widget buildButton(SdrBuildWidgetData build) {
    final data = build.data;
    return TextButton(
      onPressed: () => executeActions(_v(data['@click'], build), build),
      onLongPress: data['@longPress'] == null
          ? null
          : () => executeActions(_v(data['@longPress'], build), build),
      child: buildWidget(
        build.nested(_v(data['child'], build)),
      ),
      style: _getButtonStyle(data['style'], build),
    );
  }

  static ButtonStyle? _getButtonStyle(
      Map<String, dynamic>? data, SdrBuildWidgetData build) {
    if (data == null) {
      return null;
    }

    return ButtonStyle(
      textStyle: data['text'] == null
          ? null
          : MaterialStateProperty.all(
              _getTextStyle(data['text'], build),
            ),
      backgroundColor: data['backgroundColor'] == null
          ? null
          : MaterialStateProperty.all(
              HexColor.fromHex(_v(data['backgroundColor'], build)),
            ),
    );
  }

  static Widget buildScrollView(SdrBuildWidgetData build) {
    final data = build.data;
    final controller = ScrollController();
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: _v(data['direction'], build) == 'horizontal'
          ? Axis.horizontal
          : Axis.vertical,
      child: data['child'] == null
          ? null
          : buildWidget(build.nested(_v(data['child'], build))),
    );
  }

  static Widget buildInkWell(SdrBuildWidgetData build) {
    final data = build.data;
    return InkWell(
      child: data['child'] == null
          ? null
          : buildWidget(build.nested(_v(data['child'], build))),
      onTap: () => executeActions(_v(data['@click'], build), build),
    );
  }

  static Widget buildWrap(SdrBuildWidgetData build) {
    final data = build.data;
    final List<dynamic> children = _v(data['children'], build);
    return Wrap(
      children: children.map((e) => buildWidget(build.nested(e))).toList(),
      direction: _v(data['direction'], build) == 'vertical'
          ? Axis.vertical
          : Axis.horizontal,
    );
  }

  static Widget buildExpanded(SdrBuildWidgetData build) {
    final data = build.data;
    return Expanded(
      child: buildWidget(build.nested(_v(data['child'], build))),
      flex: _v(data['flex'], build) ?? 1,
    );
  }

  static Widget buildSdrArea(SdrBuildWidgetData build) {
    // return SdrArea(
    //   areaId: _v(build.data['area_id'], build),
    //   parentId: build.areaId,
    // );
    return Obx(
      () => sdrAreaWidget[_v(build.data['area_id'], build)] ?? const SizedBox(),
    );
  }

  static Widget buildCenter(SdrBuildWidgetData build) {
    return Center(
      child: buildWidget(build.nested(_v(build.data['child'], build))),
    );
  }

  static Widget buildVerticalDivider(SdrBuildWidgetData build) {
    return VerticalDivider(
      width: _v(build.data['width'], build),
      color: build.data['color'] == null
          ? null
          : HexColor.fromHex(
              _v(build.data['color'], build),
            ),
    );
  }

  static Widget buildDivider(SdrBuildWidgetData build) {
    return Divider(
      height: _v(build.data['height'], build),
      color: build.data['color'] == null
          ? null
          : HexColor.fromHex(
              _v(build.data['color'], build),
            ),
    );
  }

  static T? enumFromString<T>(Iterable<T> values, String? value) {
    if (value == null) {
      return null;
    }
    return values
        .firstWhere((type) => type.toString().split(".").last == value);
  }

  static Widget buildImage(SdrBuildWidgetData build) {
    final data = build.data;
    final String source = _v(data['source'], build) ?? 'file';

    switch (source) {
      case 'file':
        return Image.file(
          File(_v(data['value'], build)),
          width: _v(data['width'], build),
          height: _v(data['height'], build),
          fit: enumFromString(BoxFit.values, _v(data['fit'], build)),
        );
      case 'network':
        return Image.network(
          _v(data['value'], build),
          width: _v(data['width'], build),
          height: _v(data['height'], build),
          fit: enumFromString(BoxFit.values, _v(data['fit'], build)),
        );
      case 'asset':
        return Image.asset(
          _v(data['value'], build),
          width: _v(data['width'], build),
          height: _v(data['height'], build),
          fit: enumFromString(BoxFit.values, _v(data['fit'], build)),
        );
      default:
        return const SizedBox();
    }
  }

  static Widget buildAudioPlayer(SdrBuildWidgetData build) {
    final data = build.data;
    return AudioPlayerWidget(
      key: ValueKey(_v(data['path'], build)),
      path: _v(data['path'], build),
    );
  }

  static Widget buildListBuilder(SdrBuildWidgetData build) {
    final data = build.data;
    List<dynamic>? items = _v(data['items'], build);
    return ListView.builder(
      controller: ScrollController(),
      scrollDirection: _v(data['direction'], build) == 'horizontal'
          ? Axis.horizontal
          : Axis.vertical,
      itemBuilder: (context, index) {
        final nested = build.nested(_v(data['child'], build));
        nested.variables['index'] = index;
        if (items != null) {
          nested.variables['item'] = items[index];
        }
        return buildWidget(nested);
      },
      itemCount: items != null ? items.length : _v(data['count'], build),
    );
  }
}
