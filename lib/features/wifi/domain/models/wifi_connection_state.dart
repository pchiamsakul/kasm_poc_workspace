import 'package:freezed_annotation/freezed_annotation.dart';

part 'wifi_connection_state.freezed.dart';

part 'wifi_connection_state.g.dart';

/// Enum representing WiFi connection status
enum WifiConnectionStatus {
  /// WiFi is connected
  connected,

  /// WiFi is disconnected
  disconnected,

  /// WiFi is connecting
  connecting,

  /// WiFi connection failed
  failed,

  /// WiFi is enabled but not connected
  enabled,

  /// WiFi is disabled
  disabled,

  /// WiFi status is unknown
  unknown,
}
