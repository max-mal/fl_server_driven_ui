import 'package:cshell/sdr/sdr.dart';

class SdrTransformers {
  static _v(dynamic value, SdrBuildWidgetData build) {
    return sdrGetVariable(value, build);
  }

  static addTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build) ?? 0;
    final bValue = _v(data['b'], build) ?? 0;

    return aValue + bValue;
  }

  static substractTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build) ?? 0;
    final bValue = _v(data['b'], build) ?? 0;

    return aValue - bValue;
  }

  static bool _toBool(value) {
    if (value == null) {
      return false;
    }

    if (value == false ||
        (value is String && value.isEmpty) ||
        (value is List && value.isEmpty)) {
      return false;
    }

    return true;
  }

  static andTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _toBool(_v(data['a'], build));
    final bValue = _toBool(_v(data['b'], build));

    if (aValue == false) {
      return false;
    }

    if (bValue == false) {
      return false;
    }

    return true;
  }

  static orTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _toBool(_v(data['a'], build));
    final bValue = _toBool(_v(data['b'], build));

    if (aValue == true) {
      return true;
    }

    if (bValue == true) {
      return true;
    }

    return false;
  }

  static notTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _toBool(_v(data['a'], build));
    return !aValue;
  }

  static eqTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    return aValue == bValue;
  }

  static gtTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    return aValue > bValue;
  }

  static gteTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    return aValue >= bValue;
  }

  static ltTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    return aValue < bValue;
  }

  static lteTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    return aValue <= bValue;
  }

  static joinTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final List<dynamic> listValue = _v(data['list'], build) ?? [];
    final String glueValue = _v(data['separator'], build) ?? "";

    return listValue.join(glueValue);
  }

  static splitTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final String strValue = _v(data['str'], build) ?? "";
    final String glueValue = _v(data['separator'], build) ?? "";

    return strValue.split(glueValue);
  }

  static replaceTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final String strValue = _v(data['str'], build) ?? "";
    final String searchValue = _v(data['search'], build) ?? "";
    final String replaceValue = _v(data['replace'], build) ?? "";

    return strValue.replaceAll(searchValue, replaceValue);
  }

  static containsTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final aValue = _v(data['a'], build);
    final bValue = _v(data['b'], build);

    if (aValue is String) {
      return aValue.contains(bValue);
    }

    if (aValue is List) {
      return aValue.contains(bValue);
    }

    if (aValue is Map) {
      return aValue.containsKey(bValue);
    }

    return false;
  }

  static lowercaseTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final String strValue = _v(data['str'], build) ?? "";

    return strValue.toLowerCase();
  }

  static uppercaseTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final String strValue = _v(data['str'], build) ?? "";

    return strValue.toUpperCase();
  }

  static trimTransformer(Map<String, dynamic> data, SdrBuildWidgetData build) {
    final String strValue = _v(data['str'], build) ?? "";

    return strValue.trim();
  }

  static filterTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final List<dynamic> listValue = _v(data['list'], build);

    return listValue.where((item) {
      final _build = build.nested({});
      _build.variables['item'] = item;
      final _value = _v(data['fn'], _build);
      return _toBool(_value);
    }).toList();
  }

  static pipelineTransformer(
      Map<String, dynamic> data, SdrBuildWidgetData build) {
    final List<Map<String, dynamic>> actions = _v(data['actions'], build);

    dynamic lastValue;
    for (final item in actions) {
      final _item = Map<String, dynamic>.from(item);
      if (!_item.containsKey('_v')) {
        _item['_v'] = 'transform';
      }

      lastValue = _v(_item, build);
      final String retName = _item['ret_name'] ?? 'ret';
      build.variables[retName] = lastValue;
    }

    return lastValue;
  }
}
