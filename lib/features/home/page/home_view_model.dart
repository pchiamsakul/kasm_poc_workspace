import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/core/base/core_platform.dart';
import 'package:kasm_poc_workspace/core/helper/continuation.dart';
import 'package:kasm_poc_workspace/core/widget/toast_utils.dart';
import 'package:kasm_poc_workspace/features/wifi/domain/services/wifi_service.dart';
import 'package:kasm_poc_workspace/gen/strings.g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

const kallangSSID = 'Suraking_Guest';

@injectable
class HomeViewModel extends BaseViewModel {
  final WifiService _wifiService;

  HomeViewModel(this._wifiService);

  final PublishSubject<String> showSuccessConnectWifi = PublishSubject();
  final BehaviorSubject<bool> showWifiBadgeMessage = BehaviorSubject.seeded(false);
  final Continuation<bool> showWifiTurnOffSuggestion = Continuation();

  final BehaviorSubject<bool> isLoading = BehaviorSubject();
  final BehaviorSubject<String?> connectedNetworkName = BehaviorSubject.seeded(null);
  var isWifiNeedRecheckWhenResume = false;

  void initialize() {
    _listenToWifiChanges();
    _startFlow();
  }

  Future<void> _startFlow() async {
    try {
      final locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        final permissionStatus = await Permission.location.request();
        if (permissionStatus.isGranted) {
          final isInArea = await _isInAreaStadium();
          if (isInArea) {
            await _checkInitialWifiState();
          }
        }
      }
    } catch (e) {}
  }

  Future<bool> _isInAreaStadium() async {
    // TODO: Implement logic to check if user is in the stadium area
    return true;
  }

  Future<void> resumeCheckWifi() async {
    if (isWifiNeedRecheckWhenResume) {
      if (await _wifiService.isWifiEnabled()) {
        connectWifi();
      }
    }
    isWifiNeedRecheckWhenResume = false;
  }

  Future<void> _checkInitialWifiState() async {
    try {
      if (CorePlatform.isAndroid) {
        final isWifiEnabled = await _wifiService.isWifiEnabled();

        if (!isWifiEnabled) {
          showWifiBadgeMessage.add(true);
          return;
        }
      }

      final networkName = await _wifiService.getWifiName();

      connectedNetworkName.add(networkName);

      if (networkName?.contains(kallangSSID) == true) {
        showWifiBadgeMessage.add(false);
      } else {
        showWifiBadgeMessage.add(true);
      }
    } catch (e) {}
  }

  void _listenToWifiChanges() {
    _wifiService.observeWifiConnection().listen((connectivityResults) {
      _checkInitialWifiState(); // Recheck state when connectivity changes
    });
  }

  Future<void> connectWifi() async {
    isWifiNeedRecheckWhenResume = false;
    if (!await _wifiService.isWifiEnabled()) {
      final isUserOpenWifiSettings = await showWifiTurnOffSuggestion.wait();
      if (isUserOpenWifiSettings) {
        isWifiNeedRecheckWhenResume = true;
      }
      return;
    }
    if (!await Permission.location.status.isGranted) {
      try {
        final status = await Permission.location.request();
        if (status.isGranted) {
          await _connectToKallangWifi();
        }
      } catch (e) {

      }
    } else {
      await _connectToKallangWifi();
    }
  }

  Future<void> _connectToKallangWifi() async {
    try {
      final success = await _wifiService.connectToWifi(
        ssid: kallangSSID,
        password: null, // Assuming it's open network
        timeoutSeconds: 30,
      );

      if (success) {
        connectedNetworkName.add(kallangSSID);
        showWifiBadgeMessage.add(false); // Hide banner on successful connection
        showToast(kallangSSID, ToastType.success);
      } else {
        showToast('Failed to connect to Kallang WiFi. Please try again.', ToastType.error);
      }
    } catch (e) {
      showToast('Connection failed: ${e.toString()}', ToastType.error);
    } finally {}
  }

  void _showLocationSettingsDialog() {
    // This would typically show a dialog to open device settings
    showToast('Please enable location in device settings to connect to WiFi.', ToastType.error);
  }

  Future<void> openWifiSettings() async {
    try {
      // Open device WiFi settings
      await SystemChannels.platform.invokeMethod('android.settings.WIFI_SETTINGS');
    } catch (e) {
      showToast('Could not open WiFi settings.', ToastType.error);
    }
  }

  Future<void> openLocationSettings() async {
    try {
      // Open device location settings
      await openAppSettings();
    } catch (e) {
      showToast('Could not open location settings.', ToastType.error);
    }
  }

  void dismissWifiBanner() {
    showWifiBadgeMessage.add(false);
  }

  void showToast(String message, ToastType type) {
    switch (type) {
      case ToastType.success:
        showSuccessConnectWifi.add(message);
        break;
      case ToastType.error:
        // TODO
        break;
      default:
      // do nothing
    }
  }

  @override
  void dispose() {
    showWifiBadgeMessage.close();
    connectedNetworkName.close();
    super.dispose();
  }
}
