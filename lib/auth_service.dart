import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.8.186:8000/api';  



Future<String?> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('$baseUrl/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final token = data['token'];
    await _saveToken(token);
    return token;
  } else {
    throw Exception('Login failed: ${response.body}');
  }
}


  Future<String?> register(String name, String email, String password, {String? role}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        if (role != null) 'role': role,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await _saveToken(token);
      return token;
    } else {
      throw Exception('Registration failed: ${response.body}');
    }
  }

Future<String?> _getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}
Future<List<dynamic>> getProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/products'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load products: ${response.body}');
  }
}


Future<void> logout() async {
  final token = await _getToken();
  if (token == null) throw Exception('Not authenticated');

  final response = await http.post(
    Uri.parse('$baseUrl/logout'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    await _clearToken();
  } else {
    throw Exception('Logout failed: ${response.body}');
  }
}

// Get current user 
Future<Map<String, dynamic>?> getUser() async {
  final token = await _getToken();
  if (token == null) throw Exception('Not authenticated');

  final response = await http.get(
    Uri.parse('$baseUrl/user'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to get user: ${response.body}');
  }
}


Future<void> _clearToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<http.Response> getProductsRaw() async {
  return await http.get(Uri.parse('$baseUrl/products'));
}

}
