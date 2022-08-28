import 'package:cshell/sdr/sdr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SdrArea extends StatefulWidget {
  final Map<String, dynamic>? data;
  final String areaId;
  final String? parentId;
  const SdrArea({
    Key? key,
    required this.areaId,
    this.data,
    this.parentId,
  }) : super(key: key);

  @override
  State<SdrArea> createState() => _SdrAreaState();
}

class _SdrAreaState extends State<SdrArea> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => sdrAreaWidget[widget.areaId] == null
          ? const SizedBox()
          : sdrAreaWidget[widget.areaId]!,
    );
  }

  @override
  void initState() {
    super.initState();
    sdrAreaRxVariables[widget.areaId] = {};
    // ignore: invalid_use_of_protected_member
    sdrAreaWidget.value[widget.areaId] = buildWidget(
      SdrBuildWidgetData(
        areaId: widget.areaId,
        data: widget.data ?? {},
        variables: {},
      ),
    );

    if (widget.parentId != null) {
      sdrAreaWidget.listen((_) {
        sdrAreaWidget.refresh();
      });
    }
  }
}
