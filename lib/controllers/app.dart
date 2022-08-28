import 'package:cshell/api.dart';
import 'package:cshell/sdr/sdr.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final api = Get.find<ApiService>();

  @override
  void onReady() {
    _initializeMenu();
    super.onReady();
  }

  _initializeMenu() async {
    final menuUpdate = await api.getMenus();
    sdrUpdate(menuUpdate);
  }

  doSdrRequest(Map<String, dynamic> data) async {
    try {
      final params = Map<String, dynamic>.from(data);
      params.remove('_');
      final response = await api.doRequest(params);
      sdrUpdate(response);
    } catch (e) {
      Get.snackbar('Error', 'Failed to perform request');
    }
  }
}
