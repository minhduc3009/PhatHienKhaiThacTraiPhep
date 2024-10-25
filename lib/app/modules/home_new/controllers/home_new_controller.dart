// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class HomeNewController extends GetxController {
  var counter = '0'.obs;
  var nguongCB = 50.0.obs;
  var count = 0.obs;
  var nhiet_do = 0.0.obs;
  var doam_khongkhi = 0.obs;
  var doam_dat = 0.obs;
  var do_ph = 0.0.obs;
  var relay_1 = 0.obs;
  var relay_2 = 0.obs;

  var response = ''.obs;
  Future<void> getData() async {
    var url = Uri.parse(
        // 'https://farm-care-ai-default-rtdb.asia-southeast1.firebasedatabase.app/farmcareai.json?AIzaSyDVTDhcA_POUoK_kRv9HivxkW6_7rkx7bw');
        'https://farm-care-ai-default-rtdb.asia-southeast1.firebasedatabase.app/ID3.json?AIzaSyDVTDhcA_POUoK_kRv9HivxkW6_7rkx7bw');
    var res = await http.get(url);

    if (res.statusCode == 200) {
      response.value = res.body;
      print("getdata ----------> ${response.value}");
      count.value = jsonDecode(res.body)['count'];
      nhiet_do.value = jsonDecode(res.body)['Nhietdo'];
      doam_khongkhi.value = jsonDecode(res.body)['Doam'];
      doam_dat.value = jsonDecode(res.body)['Soid'];
      do_ph.value = jsonDecode(res.body)['ph'];
      relay_1.value = jsonDecode(res.body)['Relay-1'];
      relay_2.value = jsonDecode(res.body)['Relay-2'];
      print("count ----------> ${count.value}");
      print("nhiet_do ----------> ${nhiet_do.value}");
      print("doam_khongkhi ----------> ${doam_khongkhi.value}");
      print("doam_dat ----------> ${doam_dat.value}");
      print("do_ph ----------> ${do_ph.value}");
      print("relay_1 ----------> ${relay_1.value}");
      print("relay_2 ----------> ${relay_2.value}");
    } else {
      response.value = 'Error';
    }
  }

  Future<void> updateRelayState_1(bool newState) async {
    var url = Uri.parse(
        'https://farm-care-ai-default-rtdb.asia-southeast1.firebasedatabase.app/ID3.json');

    Map<String, dynamic> newData = {
      'count': count.value,
      'Doam': doam_khongkhi.value,
      'Nhietdo': nhiet_do.value,
      'Soid': doam_dat.value,
      'ph': do_ph.value,
      'Relay-1': newState ? 1 : 0,
      'Relay-2': relay_2.value,
    };

    try {
      // Send a PUT request to update the data
      var res = await http.put(
        url,
        body: jsonEncode(newData),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        getData();
      } else {
        response.value = 'Error updating data';
      }
    } catch (error) {
      response.value = 'Error: $error';
    }
  }

  Future<void> updateRelayState_2(bool newState) async {
    var url = Uri.parse(
        'https://farm-care-ai-default-rtdb.asia-southeast1.firebasedatabase.app/ID3.json');

    Map<String, dynamic> newData = {
      'count': count.value,
      'Doam': doam_khongkhi.value,
      'Nhietdo': nhiet_do.value,
      'Soid': doam_dat.value,
      'ph': do_ph.value,
      'Relay-1': relay_1.value,
      'Relay-2': newState ? 1 : 0,
    };

    try {
      // Send a PUT request to update the data
      var res = await http.put(
        url,
        body: jsonEncode(newData),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        getData();
      } else {
        response.value = 'Error updating data';
      }
    } catch (error) {
      response.value = 'Error: $error';
    }
  }

  @override
  void onReady() {
    getData();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
