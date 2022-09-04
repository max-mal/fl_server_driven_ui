import 'package:cshell/api.dart';
import 'package:cshell/sdr/sdr.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final api = Get.find<ApiService>();
  RxnString error = RxnString();

  @override
  void onReady() {
    initializeMenu();
    super.onReady();
  }

  initializeMenu() async {
    try {
      error.value = null;
      error.refresh();
      final menuUpdate = await api.getMenus();
      sdrUpdate(menuUpdate);
    } catch (e) {
      error(e.toString());
      rethrow;
    }
  }

  doSdrRequest(Map<String, dynamic> data) async {
    try {
      final params = Map<String, dynamic>.from(data);
      params.remove('_');
      final response = await api.doRequest(params);
      sdrUpdate(response);
    } catch (e) {
      Get.snackbar('Error', 'Failed to perform request');
      rethrow;
    }
  }
}
