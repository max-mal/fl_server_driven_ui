import 'dart:io';

import 'package:cshell/sdr/sdr.dart';
import 'package:cshell/sdr/sdr_area.dart';
import 'package:cshell/widgets/audio_player.dart';
import 'package:cshell/widgets/ui_area.dart';
import 'package:cshell/widgets/ui_container.dart';
import 'package:cshell/widgets/ui_hcontainer.dart';
import 'package:flutter/material.dart';
import 'package:cshell/extensions/color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';

class SdrBuilders {
  static _v(dynamic value, SdrBuildWidgetData build) {
    return sdrGetVariable(value, build);
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
      key: UniqueKey(),
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

  static Widget buildSvgImage(SdrBuildWidgetData build) {
    final data = build.data;
    final String source = _v(data['source'], build) ?? 'file';

    try {
      switch (source) {
        case 'file':
          return SvgPicture.file(
            File(_v(data['value'], build)),
            key: ValueKey(_v(data['value'], build)),
            width: _v(data['width'], build),
            height: _v(data['height'], build),
            fit: enumFromString(BoxFit.values, _v(data['fit'], build)) ??
                BoxFit.contain,
          );
        case 'network':
          return SvgPicture.network(
            _v(data['value'], build),
            width: _v(data['width'], build),
            height: _v(data['height'], build),
            fit: enumFromString(BoxFit.values, _v(data['fit'], build)) ??
                BoxFit.contain,
          );
        case 'asset':
          return SvgPicture.asset(
            _v(data['value'], build),
            width: _v(data['width'], build),
            height: _v(data['height'], build),
            fit: enumFromString(BoxFit.values, _v(data['fit'], build)) ??
                BoxFit.contain,
          );
        default:
          return const SizedBox();
      }
    } catch (e) {
      return const Icon(Icons.error);
    }
  }

  static Widget buildImage(SdrBuildWidgetData build) {
    final data = build.data;
    final String source = _v(data['source'], build) ?? 'file';

    String? value = _v(data['value'], build);

    if (value == null) {
      return const SizedBox();
    }

    if (value.endsWith('.svg')) {
      return buildSvgImage(build);
    }

    switch (source) {
      case 'file':
        return Image.file(
          File(_v(data['value'], build) ?? ''),
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

  static Widget buildSizedBox(SdrBuildWidgetData build) {
    final data = build.data;
    return SizedBox(
      child: data['child'] == null
          ? null
          : buildWidget(build.nested(_v(data['child'], build))),
      width: _v(data['width'], build),
      height: _v(data['height'], build),
    );
  }

  static Widget buildAlertDialog(SdrBuildWidgetData build) {
    final data = build.data;
    final List<dynamic>? actions = _v(data['actions'], build);
    return AlertDialog(
      title: data['title'] == null
          ? null
          : buildWidget(build.nested(_v(data['title'], build))),
      content: data['child'] == null
          ? null
          : buildWidget(build.nested(_v(data['child'], build))),
      actions: actions == null
          ? [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('OK'),
              )
            ]
          : actions.map((e) => buildWidget(build.nested(e))).toList(),
    );
  }

  static Widget buildTextField(SdrBuildWidgetData build) {
    final data = build.data;
    final controller = TextEditingController(text: _v(data['value'], build));
    return TextField(
      autofocus: _v(data['autofocus'], build) ?? false,
      controller: controller,
      decoration: InputDecoration.collapsed(
        hintText: _v(data['hint'], build),
        hintStyle: _getTextStyle(data['hint_style'], build),
      ),
      onChanged: data['@changed'] == null
          ? null
          : (value) {
              final _build = build.nested(build.data);
              _build.variables['value'] = value;
              executeActions(_v(data['@changed'], _build), _build);
            },
      onSubmitted: data['@submit'] == null
          ? null
          : (value) {
              final _build = build.nested(build.data);
              _build.variables['value'] = value;
              executeActions(_v(data['@submit'], _build), _build);
            },
      onEditingComplete: data['@editing_complete'] == null
          ? null
          : () => executeActions(_v(data['@editing_complete'], build), build),
      keyboardType: enumFromString(
        TextInputType.values,
        _v(data['keyboard_type'], build),
      ),
      obscureText: _v(data['obscure'], build) == true,
      style: _getTextStyle(data['text_style'], build),
      enabled:
          data['enabled'] == null ? null : _v(data['enabled'], build) == true,
      maxLines: data['max_lines'] == null ? null : _v(data['max_lines'], build),
      minLines: data['min_lines'] == null ? null : _v(data['min_lines'], build),
    );
  }

  static Widget buildIcon(SdrBuildWidgetData build) {
    final data = build.data;
    return Icon(
      _getIconDataFromString(_v(data['icon'], build)),
      color: data['color'] == null
          ? null
          : HexColor.fromHex(_v(data['color'], build)),
      size: _v(data['size'], build),
    );
  }

  static IconData _getIconDataFromString(String icon) {
    // TODO add more icons
    switch (icon) {
      case "search":
        return Icons.search;
      case "error":
        return Icons.search;
      case "arrow_upward":
        return Icons.arrow_upward;
      case "arrow_downward":
        return Icons.arrow_downward;
      default:
        return Icons.error;
    }
  }

  static Widget buildDropDownButton(SdrBuildWidgetData build) {
    final data = build.data;
    Map<dynamic, String> options = Map<dynamic, String>.from(
      _v(data['options'], build),
    );

    return DropdownButton(
      value: _v(data['value'], build),
      icon: data['icon'] == null
          ? null
          : buildWidget(build.nested(_v(data['icon'], build))),
      elevation: _v(data['elevation'], build) ?? 8,
      style: _getTextStyle(_v(data['text_style'], build), build),
      items: options.keys
          .map((key) => DropdownMenuItem(
                value: key,
                child: Text(options[key] ?? ''),
              ))
          .toList(),
      onChanged: data['@changed'] == null
          ? null
          : (value) {
              final _build = build.nested(build.data);
              _build.variables['value'] = value;
              executeActions(_v(data['@changed'], _build), _build);
            },
    );
  }

  static Widget buildBoolean(SdrBuildWidgetData build) {
    final data = build.data;
    final value = _v(data['value'], build);

    if (value == null || value == false || value == 0) {
      return data['false'] == null
          ? const SizedBox()
          : buildWidget(build.nested(_v(data['false'], build)));
    }

    return data['true'] == null
        ? const SizedBox()
        : buildWidget(build.nested(_v(data['true'], build)));
  }

  static Widget buildUiContainer(SdrBuildWidgetData build) {
    final data = build.data;
    return UiContainer(
      child: buildWidget(build.nested(_v(data['child'], build))),
    );
  }

  static Widget buildUiHContainer(SdrBuildWidgetData build) {
    final data = build.data;
    return UiHContainer(
      child: buildWidget(build.nested(_v(data['child'], build))),
    );
  }

  static Widget buildUiArea(SdrBuildWidgetData build) {
    final data = build.data;
    return UiArea(
      child: buildWidget(build.nested(_v(data['child'], build))),
    );
  }

  static Widget buildHtml(SdrBuildWidgetData build) {
    final data = build.data;

    return HtmlWidget(
      _v(data['html'], build),
      baseUrl: data['url'] == null ? null : Uri.parse(_v(data['url'], build)),
      onTapUrl: data['@url'] == null
          ? null
          : (url) {
              final _build = build.nested(build.data);
              _build.variables['url'] = url;
              executeActions(_v(data['@url'], _build), _build);
              return true;
            },
    );
  }
}
