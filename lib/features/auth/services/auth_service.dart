import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/services/shared_preference_service.dart';

class AuthService {
  final SharedPreferenceService _prefsService = SharedPreferenceService();

  Future<(bool, String)> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        body: {'username': username, 'password': password},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == true) {
          final token = data['token'];
          if (token != null) {
            await _prefsService.saveToken(token.toString());

            return (true, data['message']?.toString() ?? "Login Successful");
          }
        } else {
          return (false, data['message']?.toString() ?? "Login Failed");
        }
      }
      return (false, "Login Failed");
    } catch (e) {
      return (false, e.toString());
    }
  }

  Future<void> logout() async {
    await _prefsService.removeToken();
  }

  Future<String?> getToken() async {
    return await _prefsService.getToken();
  }
}
