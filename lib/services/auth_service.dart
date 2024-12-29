import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class AuthService {
  Future<void> saveToken(String token) async {
    await storage.write(key: "jwt_token", value: token);
  }

  Future<String?> getToken() async {
    return await storage.read(key: "jwt_token");
  }

  Future<void> deleteToken() async {
    await storage.delete(key: "jwt_token");
  }
}
