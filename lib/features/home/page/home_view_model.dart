import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/features/wifi/domain/models/wifi_connection_state.dart';
import 'package:kasm_poc_workspace/features/wifi/domain/services/wifi_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart';

@injectable
class HomeViewModel extends BaseViewModel {
  final WifiService _wifiService;

  HomeViewModel(this._wifiService);

  final BehaviorSubject<bool> shouldShowWifiBadge = BehaviorSubject.seeded(true);
  final BehaviorSubject<WifiConnectionStatus> wifiConnectionStatus =
  BehaviorSubject.seeded(WifiConnectionStatus.unknown);
  final BehaviorSubject<bool> isLocationEnabled = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> isConnecting = BehaviorSubject.seeded(false);
  final BehaviorSubject<String?> connectedNetworkName = BehaviorSubject.seeded(null);

  void initialize() {
    _checkInitialWifiState();
    _listenToWifiChanges();
  }

  Future<void> _checkInitialWifiState() async {
    try {
      // Check location permission
      final locationStatus = await Permission.location.status;
      isLocationEnabled.add(locationStatus.isGranted);

      // Check if WiFi is enabled
      final isWifiEnabled = await _wifiService.isWifiEnabled();

      if (!isWifiEnabled) {
        wifiConnectionStatus.add(WifiConnectionStatus.disabled);
        return;
      }

      // Check if connected to WiFi
      final isConnected = await _wifiService.isWifiConnected();
      final networkName = await _wifiService.getWifiName();

      connectedNetworkName.add(networkName);

      if (isConnected && networkName != null) {
        wifiConnectionStatus.add(WifiConnectionStatus.connected);
        // Hide banner if already connected to Kallang WiFi
        if (networkName.toLowerCase().contains('kallang')) {
          shouldShowWifiBadge.add(false);
        }
      } else {
        wifiConnectionStatus.add(WifiConnectionStatus.disconnected);
      }
    } catch (e) {
      wifiConnectionStatus.add(WifiConnectionStatus.unknown);
    }
  }

  void _listenToWifiChanges() {
    _wifiService.observeWifiConnection().listen((connectivityResults) {
      _checkInitialWifiState(); // Recheck state when connectivity changes
    });
  }

  Future<void> connectWifi() async {
    if (!isLocationEnabled.value) {
      // Request location permission first
      await _requestLocationPermission();
      return;
    }

    await _connectToKallangWifi();
  }

  Future<void> _requestLocationPermission() async {
    try {
      final status = await Permission.location.request();
      isLocationEnabled.add(status.isGranted);

      if (status.isGranted) {
        // Proceed with WiFi connection
        await _connectToKallangWifi();
      } else if (status.isPermanentlyDenied) {
        // Show settings dialog
        _showLocationSettingsDialog();
      } else {
        showToast('Location permission is required to connect to WiFi.');
      }
    } catch (e) {
      showToast('Failed to request location permission.');
    }
  }

  Future<void> _connectToKallangWifi() async {
    try {
      isConnecting.add(true);
      wifiConnectionStatus.add(WifiConnectionStatus.connecting);

      // Check if WiFi is enabled first
      final isWifiEnabled = await _wifiService.isWifiEnabled();
      if (!isWifiEnabled) {
        // Try to enable WiFi
        await _wifiService.setWifiEnabled(true);
        // Wait a moment for WiFi to turn on
        await Future.delayed(Duration(seconds: 2));
      }

      // Simulate connecting to "Kallang_Free_WiFi" (replace with actual SSID)
      const kallangSSID = 'Kallang_Free_WiFi';

      final success = await _wifiService.connectToWifi(
        ssid: kallangSSID,
        password: null, // Assuming it's open network
        timeoutSeconds: 30,
      );

      if (success) {
        wifiConnectionStatus.add(WifiConnectionStatus.connected);
        connectedNetworkName.add(kallangSSID);
        shouldShowWifiBadge.add(false); // Hide banner on successful connection
        showToast('Successfully connected to Kallang WiFi!');
      } else {
        wifiConnectionStatus.add(WifiConnectionStatus.failed);
        showToast('Failed to connect to Kallang WiFi. Please try again.');
      }
    } catch (e) {
      wifiConnectionStatus.add(WifiConnectionStatus.failed);
      showToast('Connection failed: ${e.toString()}');
    } finally {
      isConnecting.add(false);
    }
  }

  void _showLocationSettingsDialog() {
    // This would typically show a dialog to open device settings
    showToast('Please enable location in device settings to connect to WiFi.');
  }

  Future<void> openWifiSettings() async {
    try {
      // Open device WiFi settings
      await SystemChannels.platform.invokeMethod('android.settings.WIFI_SETTINGS');
    } catch (e) {
      showToast('Could not open WiFi settings.');
    }
  }

  Future<void> openLocationSettings() async {
    try {
      // Open device location settings
      await openAppSettings();
    } catch (e) {
      showToast('Could not open location settings.');
    }
  }

  void dismissWifiBanner() {
    shouldShowWifiBadge.add(false);
  }

  void showToast(String message) {
    // Implement toast/snackbar showing logic
    // This could emit to a stream that the UI listens to
    print('Toast: $message'); // For now, just print
  }

  @override
  void dispose() {
    shouldShowWifiBadge.close();
    wifiConnectionStatus.close();
    isLocationEnabled.close();
    isConnecting.close();
    connectedNetworkName.close();
    super.dispose();
  }
}
