import 'package:cshell/sdr/sdr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SdrArea extends StatefulWidget {
  final Map<String, dynamic> data;
  final String areaId;
  const SdrArea({
    Key? key,
    required this.areaId,
    required this.data,
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
    sdrAreaWidget[widget.areaId] = buildWidget(
      SdrBuildWidgetData(
        areaId: widget.areaId,
        data: widget.data,
        variables: {},
      ),
    );
  }
}
