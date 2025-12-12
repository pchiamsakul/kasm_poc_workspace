import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

@lazySingleton
class WifiService {
  final Connectivity _connectivity = Connectivity();
  static const _temporaryChannel = MethodChannel('wifi_temporary_connection');

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

  /// Connects to a WiFi network using temporary network binding (Android 10+)
  /// This approach uses NetworkCapabilities.TRANSPORT_WIFI and binds the process
  /// to the network temporarily without affecting system WiFi settings.
  /// 
  /// Parameters:
  /// - [ssid]: The network name to connect to
  /// - [password]: The network password (optional for open networks)
  /// - [timeoutSeconds]: Connection timeout in seconds (default: 30)
  /// 
  /// Returns true if connection was successful, false otherwise
  /// 
  /// Example usage:
  /// ```dart
  /// final wifiService = getIt<WifiService>();
  /// 
  /// // Connect to a temporary WiFi network
  /// final connected = await wifiService.connectToWifiTemporary(
  ///   ssid: 'MyNetwork',
  ///   password: 'mypassword',
  ///   timeoutSeconds: 30,
  /// );
  /// 
  /// if (connected) {
  ///   print('Connected to temporary network');
  ///   
  ///   // Check if temporary network is active
  ///   final isActive = await wifiService.isTemporaryNetworkConnected();
  ///   print('Temporary network active: $isActive');
  ///   
  ///   // Your network operations here...
  ///   
  ///   // Disconnect when done
  ///   await wifiService.disconnectTemporaryNetwork();
  /// }
  /// ```
  /// 
  /// Note: This only works on Android 10+ and iOS. Falls back to regular connection on older versions.
  /// 
  /// Benefits of temporary network connection:
  /// - Doesn't change system WiFi settings
  /// - Doesn't require user interaction for connection
  /// - Network binding is process-specific
  /// - Automatically cleaned up when app terminates
  Future<bool> connectToWifiTemporary({
    required String ssid,
    String? password,
    int timeoutSeconds = 30,
  }) async {
    try {
      if (Platform.isAndroid) {
        // Use temporary network binding for Android 10+
        final result = await _temporaryChannel.invokeMethod<bool>(
          'connectToWifiTemporary',
          {
            'ssid': ssid,
            'password': password,
            'timeoutSeconds': timeoutSeconds,
          },
        );
        return result ?? false;
      } else if (Platform.isIOS) {
        // iOS uses NEHotspotConfiguration which is similar to temporary binding
        // Fall back to the regular connect method for iOS
        return await connectToWifi(
          ssid: ssid,
          password: password,
          timeoutSeconds: timeoutSeconds,
        );
      } else {
        // For other platforms, fall back to regular connection
        return await connectToWifi(
          ssid: ssid,
          password: password,
          timeoutSeconds: timeoutSeconds,
        );
      }
    } catch (e) {
      return false;
    }
  }

  /// Disconnects from the temporary WiFi network (Android only)
  /// This unbinds the process from the temporary network without affecting system WiFi
  /// 
  /// Returns true if disconnection was successful, false otherwise
  Future<bool> disconnectTemporaryNetwork() async {
    try {
      if (Platform.isAndroid) {
        final result = await _temporaryChannel.invokeMethod<bool>(
          'disconnectTemporaryNetwork',
        );
        return result ?? false;
      } else {
        // For iOS and other platforms, use regular disconnect
        return await disconnectFromWifi();
      }
    } catch (e) {
      return false;
    }
  }

  /// Checks if a temporary network is currently connected (Android only)
  /// 
  /// Returns true if the process is bound to a temporary WiFi network
  Future<bool> isTemporaryNetworkConnected() async {
    try {
      if (Platform.isAndroid) {
        final result = await _temporaryChannel.invokeMethod<bool>(
          'isTemporaryNetworkConnected',
        );
        return result ?? false;
      } else {
        // For other platforms, check regular connection
        return await isWifiConnected();
      }
    } catch (e) {
      return false;
    }
  }

}