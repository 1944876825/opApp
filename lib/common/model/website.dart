class WebsiteItem {
  final int id;
  final String name;
  final String domain;
  final int port;
  final String type;
  final String rootPath;
  final bool enableSSL;
  final bool enableBackup;
  final bool enableMonitor;
  final bool enableIPv6;
  final bool enableFTP;
  final bool enableGzip;
  final bool enableCache;
  final bool enableLog;
  final String? remark;
  final String? runtimeId;
  final String? runtimeTypeName;
  final String? runtimeVersion;
  final String? appId;
  final String? appKey;
  final String? proxyTarget;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  WebsiteItem({
    required this.id,
    required this.name,
    required this.domain,
    required this.port,
    required this.type,
    required this.rootPath,
    required this.enableSSL,
    required this.enableBackup,
    required this.enableMonitor,
    required this.enableIPv6,
    required this.enableFTP,
    required this.enableGzip,
    required this.enableCache,
    required this.enableLog,
    this.remark,
    this.runtimeId,
    this.runtimeTypeName,
    this.runtimeVersion,
    this.appId,
    this.appKey,
    this.proxyTarget,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory WebsiteItem.fromJson(Map<String, dynamic> json) {
    return WebsiteItem(
      id: json['id'],
      name: json['name'],
      domain: json['domain'],
      port: json['port'],
      type: json['type'],
      rootPath: json['rootPath'],
      enableSSL: json['enableSSL'] ?? false,
      enableBackup: json['enableBackup'] ?? false,
      enableMonitor: json['enableMonitor'] ?? false,
      enableIPv6: json['enableIPv6'] ?? false,
      enableFTP: json['enableFTP'] ?? false,
      enableGzip: json['enableGzip'] ?? false,
      enableCache: json['enableCache'] ?? false,
      enableLog: json['enableLog'] ?? false,
      remark: json['remark'],
      runtimeId: json['runtimeId'],
      runtimeTypeName: json['runtimeType'],
      runtimeVersion: json['runtimeVersion'],
      appId: json['appId'],
      appKey: json['appKey'],
      proxyTarget: json['proxyTarget'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
} 