import 'package:flutter/material.dart';

class RuntimeItem {
  final int id;
  final String name;
  final String resource;
  final int appDetailID;
  final int appID;
  final String source;
  final String status;
  final String type;
  final String image;
  final Map<String, dynamic> params;
  final String message;
  final String version;
  final DateTime createdAt;
  final String codeDir;
  final dynamic appParams;
  final int port;
  final String path;
  final dynamic exposedPorts;

  RuntimeItem({
    required this.id,
    required this.name,
    required this.resource,
    required this.appDetailID,
    required this.appID,
    required this.source,
    required this.status,
    required this.type,
    required this.image,
    required this.params,
    required this.message,
    required this.version,
    required this.createdAt,
    required this.codeDir,
    this.appParams,
    required this.port,
    required this.path,
    this.exposedPorts,
  });

  factory RuntimeItem.fromJson(Map<String, dynamic> json) {
    return RuntimeItem(
      id: json['id'],
      name: json['name'],
      resource: json['resource'],
      appDetailID: json['appDetailID'],
      appID: json['appID'],
      source: json['source'],
      status: json['status'],
      type: json['type'],
      image: json['image'],
      params: json['params'] ?? {},
      message: json['message'] ?? '',
      version: json['version'],
      createdAt: DateTime.parse(json['createdAt']),
      codeDir: json['codeDir'] ?? '',
      appParams: json['appParams'],
      port: json['port'] ?? 0,
      path: json['path'] ?? '',
      exposedPorts: json['exposedPorts'],
    );
  }

  // 获取运行环境显示名称
  String get displayName {
    if (type == 'node') {
      return 'Node.js ${version}';
    } else if (type == 'php') {
      return 'PHP ${version}';
    } else if (type == 'python') {
      return 'Python ${version}';
    } else if (type == 'java') {
      return 'Java ${version}';
    } else if (type == 'go') {
      return 'Go ${version}';
    } else if (type == 'dotnet') {
      return '.NET ${version}';
    }
    return '${type.toUpperCase()} ${version}';
  }

  // 获取运行环境状态显示
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'running':
        return '运行中';
      case 'stopped':
        return '已停止';
      case 'starting':
        return '启动中';
      case 'stopping':
        return '停止中';
      case 'error':
        return '错误';
      default:
        return status;
    }
  }

  // 获取运行环境状态颜色
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'running':
        return Colors.green;
      case 'stopped':
        return Colors.red;
      case 'starting':
      case 'stopping':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 