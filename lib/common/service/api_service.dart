import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Map<String, String> headers;

  ApiService({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : headers = headers ?? {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        };

  Future<http.Response> get(String path) async {
    final response = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> post(String path, dynamic data) async {
    final response = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: json.encode(data),
    );
    return response;
  }

  Future<http.Response> put(String path, dynamic data) async {
    final response = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: headers,
      body: json.encode(data),
    );
    return response;
  }

  Future<http.Response> delete(String path) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: headers,
    );
    return response;
  }
} 