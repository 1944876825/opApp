import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/website.dart';
import 'api_service.dart';

class WebsiteService {
  final ApiService _apiService;

  WebsiteService(this._apiService);

  Future<List<WebsiteItem>> getWebsites() async {
    final response = await _apiService.get('/api/v1/websites');
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => WebsiteItem.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load websites');
    }
  }

  Future<WebsiteItem> getWebsite(int id) async {
    final response = await _apiService.get('/api/v1/websites/$id');
    if (response.statusCode == 200) {
      return WebsiteItem.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to load website');
    }
  }

  Future<WebsiteItem> createWebsite(Map<String, dynamic> data) async {
    final response = await _apiService.post('/api/v1/websites', data);
    if (response.statusCode == 200) {
      return WebsiteItem.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create website');
    }
  }

  Future<WebsiteItem> updateWebsite(int id, Map<String, dynamic> data) async {
    final response = await _apiService.put('/api/v1/websites/$id', data);
    if (response.statusCode == 200) {
      return WebsiteItem.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update website');
    }
  }

  Future<void> deleteWebsite(int id) async {
    final response = await _apiService.delete('/api/v1/websites/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete website');
    }
  }

  Future<void> startWebsite(int id) async {
    final response = await _apiService.post('/api/v1/websites/$id/start', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to start website');
    }
  }

  Future<void> stopWebsite(int id) async {
    final response = await _apiService.post('/api/v1/websites/$id/stop', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to stop website');
    }
  }

  Future<void> restartWebsite(int id) async {
    final response = await _apiService.post('/api/v1/websites/$id/restart', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to restart website');
    }
  }

  Future<void> backupWebsite(int id) async {
    final response = await _apiService.post('/api/v1/websites/$id/backup', {});
    if (response.statusCode != 200) {
      throw Exception('Failed to backup website');
    }
  }

  Future<void> restoreWebsite(int id, String backupId) async {
    final response = await _apiService.post('/api/v1/websites/$id/restore', {
      'backupId': backupId,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to restore website');
    }
  }

  Future<void> uploadWebsite(int id, List<int> fileBytes, String fileName) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${_apiService.baseUrl}/api/v1/websites/$id/upload'),
    );
    request.headers.addAll(_apiService.headers);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: fileName,
      ),
    );
    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload file');
    }
  }
} 