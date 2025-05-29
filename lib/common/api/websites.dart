import 'package:op_app/common/http/dio.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/websites.dart';
import '../model/website.dart';
import '../model/file_item.dart';
import '../service/api_service.dart';

class ApiWebsites {
  static final ApiService _apiService = ApiService(baseUrl: 'http://your-api-url');

  static FutureBaseRes<List<WebSiteItem>> getList(
      {String state = "all",
      int page = 1,
      int pageSize = 10,
      String filters = "",
      String orderBy = "created_at",
      String order = "null",
      bool excludeAppStore = false}) async {
    return await myDio.myFetch("/websites/list", (data) {
      return data.map<WebSiteItem>((e) => WebSiteItem.fromJson(e)).toList();
    }, method: "GET");
  }

  static FutureBaseRes<void> toggleStatus(String id) async {
    return await myDio.myFetch(
      '/websites/status',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<void> restart(String id) async {
    return await myDio.myFetch(
      '/websites/restart',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<void> delete(String id) async {
    return await myDio.myFetch(
      '/websites/delete',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<String> getLog(String id) async {
    return await myDio.myFetch(
      '/websites/log/$id',
      (data) => data.toString(),
      method: 'GET',
    );
  }

  static FutureBaseRes<void> create(Map<String, dynamic> data) async {
    return await myDio.myFetch(
      '/websites/create',
      (data) => null,
      data: data,
      method: 'POST',
    );
  }

  // 检查端口是否可用
  static FutureBaseRes<bool> checkPort(int port) async {
    return await myDio.myFetch("/websites/check-port", (data) {
      return data ?? false;
    }, data: {"port": port});
  }

  static FutureBaseRes<List<FileItem>> listFiles(
    String websiteId,
    String path, {
    bool expand = true,
    bool showHidden = true,
    int page = 1,
    int pageSize = 100,
    String search = "",
    bool containSub = false,
    String sortBy = "name",
    String sortOrder = "ascending",
  }) async {
    print({
      'path': path,
      'expand': expand,
      'showHidden': showHidden,
      'page': page,
      'pageSize': pageSize,
      'search': search,
      'containSub': containSub,
      'sortBy': sortBy,
      'sortOrder': sortOrder,
    }.toString());
    return await myDio.myFetch('/files/search', (data) {
      print("mydebug listFiles $data");
      if (data != null && data['items'] != null) {
        List<dynamic> items = data['items'];
        return items.map<FileItem>((e) => FileItem.fromJson(e)).toList();
      }
      return <FileItem>[];
    },
      data: {
        'path': path,
        'expand': expand,
        'showHidden': showHidden,
        'page': page,
        'pageSize': pageSize,
        'search': search,
        'containSub': containSub,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
  }

  // 获取当前目录信息
  static FutureBaseRes<FileItem> getCurrentDir(String path) async {
    return await myDio.myFetch('/files/search', (data) {
      if (data != null) {
        return FileItem.fromJson(data);
      }
      throw Exception('Failed to get directory info');
    },
      data: {
        'path': path,
        'expand': false,
        'showHidden': true,
        'page': 1,
        'pageSize': 1,
        'search': "",
        'containSub': false,
        'sortBy': "name",
        'sortOrder': "ascending",
      },
    );
  }

  // 进入子目录
  static String enterSubDir(String currentPath, String subDir) {
    if (currentPath.isEmpty) {
      return '/' + subDir;
    }
    if (currentPath.endsWith('/')) {
      return currentPath + subDir;
    }
    return currentPath + '/' + subDir;
  }

  // 返回上级目录
  static String goToParentDir(String currentPath) {
    if (currentPath.isEmpty || currentPath == '/') {
      return '/';
    }

    // 移除末尾的斜杠
    if (currentPath.endsWith('/')) {
      currentPath = currentPath.substring(0, currentPath.length - 1);
    }

    // 分割路径并移除空部分
    final parts = currentPath.split('/');
    parts.removeWhere((part) => part.isEmpty);

    // 如果已经是根目录，返回根目录
    if (parts.isEmpty) {
      return '/';
    }

    // 移除最后一部分
    parts.removeLast();

    // 如果移除后为空，返回根目录
    if (parts.isEmpty) {
      return '/';
    }

    // 重新组合路径
    return '/' + parts.join('/');
  }

  // 获取当前目录的父目录路径
  static FutureBaseRes<List<FileItem>> goToParentDirectory(String currentPath) async {
    String parentPath = goToParentDir(currentPath);
    return await listFiles(
      '',  // websiteId 在这里不需要
      parentPath,
      expand: true,
      showHidden: true,
      page: 1,
      pageSize: 100,
      search: "",
      containSub: false,
      sortBy: "name",
      sortOrder: "ascending",
    );
  }

  // 获取完整路径
  static String getFullPath(String basePath, String relativePath) {
    if (relativePath.startsWith('/')) {
      return relativePath;
    }
    if (basePath.endsWith('/')) {
      return basePath + relativePath;
    }
    return basePath + '/' + relativePath;
  }

  // 检查是否是根目录
  static bool isRootDir(String path) {
    return path == '/' || path.isEmpty;
  }

  // 获取目录名称
  static String getDirName(String path) {
    if (path.isEmpty || path == '/') {
      return '/';
    }
    final parts = path.split('/');
    return parts.last;
  }

  static FutureBaseRes<void> createFolder(String websiteId, String path) async {
    return await myDio.myFetch(
      '/websites/folders',
      (data) => null,
      data: {
        'id': websiteId,
        'path': path,
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<void> deleteFile(String websiteId, String path) async {
    return await myDio.myFetch(
      '/websites/files',
      (data) => null,
      data: {
        'id': websiteId,
        'path': path,
      },
      method: 'DELETE',
    );
  }

  static FutureBaseRes<void> renameFile(String websiteId, String path, String newName) async {
    return await myDio.myFetch(
      '/websites/files',
      (data) => null,
      data: {
        'id': websiteId,
        'path': path,
        'newName': newName,
      },
      method: 'PUT',
    );
  }

  // SSH 相关功能
  static FutureBaseRes<Map<String, dynamic>> connectSSH(String host, int port, String username, String password) async {
    return await myDio.myFetch('/ssh/connect', (data) {
      return data;
    },
      data: {
        'host': host,
        'port': port,
        'username': username,
        'password': password,
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<Map<String, dynamic>> executeCommand(String sessionId, String command) async {
    return await myDio.myFetch('/ssh/execute', (data) {
      return data;
    },
      data: {
        'sessionId': sessionId,
        'command': command,
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<void> uploadFile(String sessionId, String localPath, String remotePath) async {
    return await myDio.myFetch('/ssh/upload', (data) {
      return null;
    },
      data: {
        'sessionId': sessionId,
        'localPath': localPath,
        'remotePath': remotePath,
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<void> downloadFile(String sessionId, String remotePath, String localPath) async {
    return await myDio.myFetch('/ssh/download', (data) {
      return null;
    },
      data: {
        'sessionId': sessionId,
        'remotePath': remotePath,
        'localPath': localPath,
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<void> closeSSH(String sessionId) async {
    return await myDio.myFetch('/ssh/close', (data) {
      return null;
    },
      data: {
        'sessionId': sessionId,
      },
      method: 'POST',
    );
  }

  // 获取SSH连接状态
  static FutureBaseRes<bool> getSSHStatus(String sessionId) async {
    return await myDio.myFetch('/ssh/status', (data) {
      return data ?? false;
    },
      data: {
        'sessionId': sessionId,
      },
      method: 'GET',
    );
  }

  // 获取SSH连接历史
  static FutureBaseRes<List<Map<String, dynamic>>> getSSHHistory() async {
    return await myDio.myFetch('/ssh/history', (data) {
      return (data as List).map((e) => e as Map<String, dynamic>).toList();
    },
      method: 'GET',
    );
  }

  // 保存SSH连接配置
  static FutureBaseRes<void> saveSSHConfig(Map<String, dynamic> config) async {
    return await myDio.myFetch('/ssh/config', (data) {
      return null;
    },
      data: config,
      method: 'POST',
    );
  }

  // 获取SSH连接配置列表
  static FutureBaseRes<List<Map<String, dynamic>>> getSSHConfigs() async {
    return await myDio.myFetch('/ssh/configs', (data) {
      return (data as List).map((e) => e as Map<String, dynamic>).toList();
    },
      method: 'GET',
    );
  }

  // 删除SSH连接配置
  static FutureBaseRes<void> deleteSSHConfig(String configId) async {
    return await myDio.myFetch('/ssh/config', (data) {
      return null;
    },
      data: {
        'id': configId,
      },
      method: 'DELETE',
    );
  }

  // 测试SSH连接
  static FutureBaseRes<bool> testSSHConnection(String host, int port, String username, String password) async {
    return await myDio.myFetch('/ssh/test', (data) {
      return data ?? false;
    },
      data: {
        'host': host,
        'port': port,
        'username': username,
        'password': password,
      },
      method: 'POST',
    );
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
  });
}
