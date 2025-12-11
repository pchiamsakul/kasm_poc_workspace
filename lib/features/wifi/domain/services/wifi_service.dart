import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

@lazySingleton
class WifiService {
  final Connectivity _connectivity = Connectivity();

  /// Checks if the device is currently connected to a WiFi network
  Future<bool> isWifiConnected() async {
    try {
      final connectivityResults = await _connectivity.checkConnectivity();
      return connectivityResults.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }

  /// Checks if WiFi is enabled on the device
  Future<bool> isWifiEnabled() async {
    try {
      return await WiFiForIoTPlugin.isEnabled();
    } catch (e) {
      return false;
    }
  }

  /// Enables or disables WiFi on the device
  Future<bool> setWifiEnabled(bool enabled) async {
    try {
      await WiFiForIoTPlugin.setEnabled(enabled);
      // Wait a bit for the WiFi state to change
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the name (SSID) of the currently connected WiFi network
  /// Returns null if not connected or unable to retrieve
  Future<String?> getWifiName() async {
    try {
      final ssid = await WiFiForIoTPlugin.getSSID();
      if (ssid != null && ssid.isNotEmpty && ssid != '<unknown ssid>') {
        return ssid;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Connects to a WiFi network
  /// 
  /// Parameters:
  /// - [ssid]: The network name to connect to
  /// - [password]: The network password (optional for open networks)
  /// - [isHidden]: Whether this is a hidden network
  /// - [timeoutSeconds]: Connection timeout in seconds (default: 30)
  /// 
  /// Returns true if connection was successful, false otherwise
  Future<bool> connectToWifi({
    required String ssid,
    String? password,
    bool isHidden = false,
    int timeoutSeconds = 30,
  }) async {
    try {
      // Enable WiFi if not already enabled
      bool wifiEnabled = await isWifiEnabled();
      if (!wifiEnabled) {
        await setWifiEnabled(true);
      }

      // Determine network security type
      NetworkSecurity security = password != null && password.isNotEmpty
          ? NetworkSecurity.WPA
          : NetworkSecurity.NONE;

      // Connect to the WiFi network with timeout
      final connectFuture = WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        security: security,
        joinOnce: true,
        withInternet: true,
        isHidden: isHidden,
      );

      // Add timeout
      bool connected = await connectFuture.timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () => false,
      );

      return connected;
    } catch (e) {
      return false;
    }
  }

  /// Disconnects from the current WiFi network
  /// Returns true if disconnection was successful, false otherwise
  Future<bool> disconnectFromWifi() async {
    try {
      await WiFiForIoTPlugin.disconnect();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if WiFi scanning is available on this device
  Future<bool> canScanWifi() async {
    try {
      final canScan = await WiFiScan.instance.canStartScan();
      return canScan == CanStartScan.yes;
    } catch (e) {
      return false;
    }
  }

  /// Checks and requests location permission (required for WiFi scanning)
  Future<bool> checkLocationPermission() async {
    try {
      final status = await Permission.location.status;
      if (status.isGranted) {
        return true;
      }

      final result = await Permission.location.request();
      return result.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Scans for available WiFi networks
  /// 
  /// Parameters:
  /// - [scanDelaySeconds]: Delay after starting scan to wait for results (default: 2)
  /// 
  /// Returns a list of WiFiAccessPoint objects, or empty list if scan fails
  Future<List<WiFiAccessPoint>> scanWifiNetworks({
    int scanDelaySeconds = 2,
  }) async {
    try {
      // Check location permission
      final hasPermission = await checkLocationPermission();
      if (!hasPermission) {
        return [];
      }

      // Check if scan is possible
      final canScan = await WiFiScan.instance.canStartScan();
      if (canScan != CanStartScan.yes) {
        return [];
      }

      // Start WiFi scan
      await WiFiScan.instance.startScan();

      // Wait for scan to complete
      await Future.delayed(Duration(seconds: scanDelaySeconds));

      // Get scan results
      final results = await WiFiScan.instance.getScannedResults();

      return results;
    } catch (e) {
      return [];
    }
  }

  /// Observes WiFi connection changes
  /// Returns a stream that emits connectivity results whenever the connection status changes
  Stream<List<ConnectivityResult>> observeWifiConnection() {
    return _connectivity.onConnectivityChanged;
  }

  /// Checks if a specific WiFi network is currently connected
  Future<bool> isConnectedToNetwork(String ssid) async {
    try {
      final currentSsid = await getWifiName();
      return currentSsid?.toLowerCase() == ssid.toLowerCase();
    } catch (e) {
      return false;
    }
  }

}