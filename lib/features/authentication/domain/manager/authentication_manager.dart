import 'package:injectable/injectable.dart';

@lazySingleton
class AuthenticationManager {
  Future<dynamic> getTokenExpiryTime() async {
    // TODO: implement getTokenExpiryTime
  }

  Future<dynamic> getRefreshToken() async {
    // TODO: implement getTokenExpiryTime
  }

  Future<dynamic> refreshToken(refreshToken) async {
    // TODO: implement getTokenExpiryTime
  }

  Future<void> saveTokens({required accessToken, required refreshToken, required expiresIn}) async {
    // TODO: implement getTokenExpiryTime
  }

  Future<dynamic> getAccessToken() async {
    // TODO: implement getTokenExpiryTime
  }
}
