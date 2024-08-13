import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        "Oops! No internet connection",
        "PLEASE CONNECT TO THE INTERNET",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(days: 1),
        colorText: Colors.white,
        backgroundColor: Colors.red,
        icon: const Icon(Icons.wifi_off, color: Colors.white, size: 100),
        margin: const EdgeInsets.all(16),
      );
    } else {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
        Get.snackbar(
          "welcome back",
          "CONNECTION ESTABLISHED",
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
          colorText: Colors.white,
          backgroundColor: Colors.black,
          icon: const Icon(Icons.wifi_off, color: Colors.white, size: 100),
          margin: const EdgeInsets.all(16),
        );
      }
    }
  }
}