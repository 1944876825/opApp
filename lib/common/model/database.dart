class DatabaseItem {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String type;
  String version;
  String status;
  String username;
  String password;
  int port;
  String host;
  String charset;
  String command;
  String dataPath;
  String logPath;
  String slowLogPath;
  String backupPath;
  bool enableRemoteAccess;
  bool enableSlowLog;
  bool enableBinLog;

  DatabaseItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.type,
    required this.version,
    required this.status,
    required this.username,
    required this.password,
    required this.port,
    required this.host,
    required this.charset,
    required this.command,
    required this.dataPath,
    required this.logPath,
    required this.slowLogPath,
    required this.backupPath,
    required this.enableRemoteAccess,
    required this.enableSlowLog,
    required this.enableBinLog,
  });

  factory DatabaseItem.fromJson(Map<String, dynamic> json) => DatabaseItem(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        type: json["type"],
        version: json["version"],
        status: json["status"],
        username: json["username"],
        password: json["password"],
        port: json["port"],
        host: json["host"],
        charset: json["charset"],
        command: json["command"],
        dataPath: json["dataPath"],
        logPath: json["logPath"],
        slowLogPath: json["slowLogPath"],
        backupPath: json["backupPath"],
        enableRemoteAccess: json["enableRemoteAccess"],
        enableSlowLog: json["enableSlowLog"],
        enableBinLog: json["enableBinLog"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "type": type,
        "version": version,
        "status": status,
        "username": username,
        "password": password,
        "port": port,
        "host": host,
        "charset": charset,
        "command": command,
        "dataPath": dataPath,
        "logPath": logPath,
        "slowLogPath": slowLogPath,
        "backupPath": backupPath,
        "enableRemoteAccess": enableRemoteAccess,
        "enableSlowLog": enableSlowLog,
        "enableBinLog": enableBinLog,
      };
} 