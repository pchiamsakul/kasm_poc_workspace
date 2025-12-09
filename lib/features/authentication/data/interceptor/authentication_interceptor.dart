import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:kasm_poc_workspace/features/authentication/domain/manager/authentication_manager.dart';
import 'package:synchronized/synchronized.dart';

@lazySingleton
class AuthenticationInterceptor extends Interceptor {
  final AuthenticationManager _authenticationManager;
  final Lock _lock = Lock();

  bool _isBusy = false;

  static const int tokenRefreshThreshold = 15 * 60 * 1000;

  AuthenticationInterceptor(this._authenticationManager);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      await _checkAndRefreshToken();

      final accessToken = await _authenticationManager.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(requestOptions: options, error: e, type: DioExceptionType.unknown),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token might be invalid
    if (err.response?.statusCode == 401) {
      try {
        // Force refresh token
        await _forceRefreshToken();

        // Retry the failed request with new token
        final accessToken = await _authenticationManager.getAccessToken();
        if (accessToken != null && accessToken.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

          // Retry the request
          final response = await Dio().fetch(err.requestOptions);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // If refresh fails, reject with original error
        handler.reject(err);
        return;
      }
    }

    handler.next(err);
  }

  /// Check if token needs refresh and refresh if necessary
  Future<void> _checkAndRefreshToken() async {
    // Step 1: Check if busy
    if (_isBusy) {
      // Wait until not busy
      await _waitUntilReady();
      return;
    }

    // Step 2: Check if token time is less than 15 minutes
    final tokenExpiryTime = await _authenticationManager.getTokenExpiryTime();
    if (tokenExpiryTime == null) {
      // No token stored, no need to refresh
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeUntilExpiry = tokenExpiryTime - now;

    // Step 3: If token expires in less than 15 minutes, refresh it
    if (timeUntilExpiry < tokenRefreshThreshold) {
      await _performTokenRefresh();
    }
    // Otherwise, continue with existing token
  }

  /// Force token refresh (used in error handling)
  Future<void> _forceRefreshToken() async {
    if (_isBusy) {
      await _waitUntilReady();
      return;
    }

    await _performTokenRefresh();
  }

  /// Wait until token refresh is complete
  Future<void> _waitUntilReady() async {
    while (_isBusy) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  /// Perform token refresh with lock to prevent concurrent refreshes
  Future<void> _performTokenRefresh() async {
    await _lock.synchronized(() async {
      // Double-check if refresh is still needed (another request might have done it)
      if (_isBusy) {
        return;
      }

      try {
        // Step 4: Set busy flag
        _isBusy = true;

        // Step 5: Refresh token
        final refreshToken = await _authenticationManager.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          throw Exception('No refresh token available');
        }

        final newTokens = await _authenticationManager.refreshToken(refreshToken);

        // Step 6: Clear busy flag
        _isBusy = false;

        // Step 7: Update new access token and refresh token
        await _authenticationManager.saveTokens(
          accessToken: newTokens.accessToken,
          refreshToken: newTokens.refreshToken,
          expiresIn: newTokens.expiresIn,
        );
      } catch (e) {
        // Clear busy flag on error
        _isBusy = false;
        rethrow;
      }
    });
  }

  /// Get current busy status
  bool get isBusy => _isBusy;

  /// Reset interceptor state (useful for testing or logout)
  void reset() {
    _isBusy = false;
  }
}
