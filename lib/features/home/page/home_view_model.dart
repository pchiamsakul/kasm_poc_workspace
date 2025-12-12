import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/core/base/base_view_model.dart';
import 'package:kasm_poc_workspace/core/base/core_platform.dart';
import 'package:kasm_poc_workspace/core/helper/continuation.dart';
import 'package:kasm_poc_workspace/features/wifi/domain/services/wifi_service.dart';
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
      isLoading.add(true);
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
    } catch (e) {
    } finally {
      isLoading.add(false);
    }
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
        showSuccessConnectWifi.add(kallangSSID);
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
    isLoading.add(true);
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
      } catch (e) {}
    } else {
      await _connectToKallangWifi();
    }

    isLoading.add(false);
  }

  Future<void> _connectToKallangWifi() async {
    try {
      await _wifiService.connectToWifiTemporary(ssid: kallangSSID, password: null, timeoutSeconds: 30);
    } catch (e) {
    } finally {}
  }

  @override
  void dispose() {
    showWifiBadgeMessage.close();
    connectedNetworkName.close();
    super.dispose();
  }
}
