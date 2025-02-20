class AppItemWrap {
  int id;
  String key;
  String name;

  AppItemWrap({
    required this.id,
    required this.key,
    required this.name,
  });

  factory AppItemWrap.fromJson(Map<String, dynamic> json) => AppItemWrap(
        id: json["id"],
        key: json["key"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "name": name,
      };
}

class AppItem {
  int id;
  String name;
  int appId;
  int appDetailId;
  String version;
  String status;
  String message;
  int httpPort;
  int httpsPort;
  String path;
  bool canUpdate;
  String icon;
  String appName;
  int ready;
  int total;
  String appKey;
  String appType;
  String appStatus;
  String dockerCompose;
  DateTime createdAt;
  App app;

  AppItem({
    required this.id,
    required this.name,
    required this.appId,
    required this.appDetailId,
    required this.version,
    required this.status,
    required this.message,
    required this.httpPort,
    required this.httpsPort,
    required this.path,
    required this.canUpdate,
    required this.icon,
    required this.appName,
    required this.ready,
    required this.total,
    required this.appKey,
    required this.appType,
    required this.appStatus,
    required this.dockerCompose,
    required this.createdAt,
    required this.app,
  });

  factory AppItem.fromJson(Map<String, dynamic> json) => AppItem(
        id: json["id"],
        name: json["name"],
        appId: json["appID"],
        appDetailId: json["appDetailID"],
        version: json["version"],
        status: json["status"],
        message: json["message"],
        httpPort: json["httpPort"],
        httpsPort: json["httpsPort"],
        path: json["path"],
        canUpdate: json["canUpdate"],
        icon: json["icon"],
        appName: json["appName"],
        ready: json["ready"],
        total: json["total"],
        appKey: json["appKey"],
        appType: json["appType"],
        appStatus: json["appStatus"],
        dockerCompose: json["dockerCompose"],
        createdAt: DateTime.parse(json["createdAt"]),
        app: App.fromJson(json["app"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "appID": appId,
        "appDetailID": appDetailId,
        "version": version,
        "status": status,
        "message": message,
        "httpPort": httpPort,
        "httpsPort": httpsPort,
        "path": path,
        "canUpdate": canUpdate,
        "icon": icon,
        "appName": appName,
        "ready": ready,
        "total": total,
        "appKey": appKey,
        "appType": appType,
        "appStatus": appStatus,
        "dockerCompose": dockerCompose,
        "createdAt": createdAt.toIso8601String(),
        "app": app.toJson(),
      };
}

class App {
  String website;
  String document;
  String github;

  App({
    required this.website,
    required this.document,
    required this.github,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        website: json["website"],
        document: json["document"],
        github: json["github"],
      );

  Map<String, dynamic> toJson() => {
        "website": website,
        "document": document,
        "github": github,
      };
}
