import 'dart:io';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  var hostname = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getHostname();
  }

  Future<void> getHostname() async {
    try {
      // Get the hostname
      hostname.value = Platform.localHostname;
    } catch (e) {
      print('Failed to get hostname: $e');
    }
  }
}