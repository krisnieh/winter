import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'network_controller.dart';

class HomeController extends GetxController {
  var counter = 0;
  var data = ''.obs;

  void incrementCounter() {
    counter++;
    update();
  }

  Future<void> toggleLights() async {
    final NetworkController networkController = Get.find();
    String hostname = networkController.hostname.value;
    String url;

    List<String> lists = hostname.split('-');

    String lineName = lists[lists.length - 2];
    String unitId = lists.last;

    switch (lineName) {
      case 'a':
        url = 'http://172.16.21.1:5000/action/';
        break;
      case 'b':
        url = 'http://172.16.21.2:5000/action/';
        break;
      case 'c':
        url = 'http://172.16.21.3:5000/action/';
        break;
      case 'd':
        url = 'http://172.16.21.4:5000/action/';
        break;
      default:
        url = 'http://172.16.0.8:5000/action/';
    }

    url += "lights/$lineName/$unitId";

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        data.value = response.data.toString();
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}