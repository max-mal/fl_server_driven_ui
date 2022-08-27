import 'package:cshell/sdr/sdr.dart';
import 'package:flutter/material.dart';
import 'package:cshell/extensions/color.dart';

class SdrBuilders {
  static _v(dynamic value, SdrBuildWidgetData build) {
    if (value == null) {
      return null;
    }

    if (value.toString().startsWith('\$\$')) {
      return sdrAreaRxVariables[build.areaId]?[value.toString().substring(2)]
          ?.value;
    }

    if (value.toString().startsWith('\$')) {
      return build.variables[value.toString().substring(1)];
    }
    return value;
  }

  static Widget buildText(SdrBuildWidgetData build) {
    final data = build.data;
    final textStyle = TextStyle(
      color: data['color'] != null
          ? HexColor.fromHex(_v(data['color'], build))
          : null,
      fontSize: data['fontSize'] == null
          ? null
          : double.tryParse(_v(data['fontSize'], build).toString()),
    );

    return Text(
      _v(data['text'], build).toString(),
      style: textStyle,
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
      case null:
        return CrossAxisAlignment.center;
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
    );
  }
}
