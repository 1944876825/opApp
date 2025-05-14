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

// 已安装应用
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

// 应用商城APP
class AppsItem {
  String name;
  String key;
  int id;
  String description;
  String icon;
  String type;
  String status;
  String resource;
  bool installed;
  dynamic versions;
  int limit;
  dynamic tags;
  bool gpuSupport;

  AppsItem({
    required this.name,
    required this.key,
    required this.id,
    required this.description,
    required this.icon,
    required this.type,
    required this.status,
    required this.resource,
    required this.installed,
    required this.versions,
    required this.limit,
    required this.tags,
    required this.gpuSupport,
  });

  factory AppsItem.fromJson(Map<String, dynamic> json) => AppsItem(
        name: json["name"],
        key: json["key"],
        id: json["id"],
        description: json["description"],
        icon: json["icon"],
        type: json["type"],
        status: json["status"],
        resource: json["resource"],
        installed: json["installed"],
        versions: json["versions"],
        limit: json["limit"],
        tags: json["tags"],
        gpuSupport: json["gpuSupport"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "key": key,
        "id": id,
        "description": description,
        "icon": icon,
        "type": type,
        "status": status,
        "resource": resource,
        "installed": installed,
        "versions": versions,
        "limit": limit,
        "tags": tags,
        "gpuSupport": gpuSupport,
      };
}

// Tag
class Tag {
  int id;
  String key;
  String name;

  Tag({
    required this.id,
    required this.key,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
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

class AppInfo {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String key;
  String shortDescZh;
  String shortDescEn;
  String description;
  String icon;
  String type;
  String status;
  String required;
  bool gpuSupport;
  bool crossVersionUpdate;
  int limit;
  String website;
  String github;
  String document;
  int recommend;
  String resource;
  String readMe;
  int lastModified;
  bool installed;
  List<String> versions;
  List<Tag> tags;

  AppInfo({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.key,
    required this.shortDescZh,
    required this.shortDescEn,
    required this.description,
    required this.icon,
    required this.type,
    required this.status,
    required this.required,
    required this.gpuSupport,
    required this.crossVersionUpdate,
    required this.limit,
    required this.website,
    required this.github,
    required this.document,
    required this.recommend,
    required this.resource,
    required this.readMe,
    required this.lastModified,
    required this.installed,
    required this.versions,
    required this.tags,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) => AppInfo(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        key: json["key"],
        shortDescZh: json["shortDescZh"],
        shortDescEn: json["shortDescEn"],
        description: json["description"],
        icon: json["icon"],
        type: json["type"],
        status: json["status"],
        required: json["required"],
        gpuSupport: json["gpuSupport"],
        crossVersionUpdate: json["crossVersionUpdate"],
        limit: json["limit"],
        website: json["website"],
        github: json["github"],
        document: json["document"],
        recommend: json["recommend"],
        resource: json["resource"],
        readMe: json["readMe"],
        lastModified: json["lastModified"],
        installed: json["installed"],
        versions: List<String>.from(json["versions"].map((x) => x)),
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "key": key,
        "shortDescZh": shortDescZh,
        "shortDescEn": shortDescEn,
        "description": description,
        "icon": icon,
        "type": type,
        "status": status,
        "required": required,
        "gpuSupport": gpuSupport,
        "crossVersionUpdate": crossVersionUpdate,
        "limit": limit,
        "website": website,
        "github": github,
        "document": document,
        "recommend": recommend,
        "resource": resource,
        "readMe": readMe,
        "lastModified": lastModified,
        "installed": installed,
        "versions": List<dynamic>.from(versions.map((x) => x)),
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
      };
}

// 安装信息
class AppDeatil {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  int appId;
  String version;
  String dockerCompose;
  String status;
  String lastVersion;
  int lastModified;
  String downloadUrl;
  String downloadCallBackUrl;
  bool update;
  bool ignoreUpgrade;
  bool enable;
  Params params;
  String image;
  bool hostMode;
  bool gpuSupport;

  AppDeatil({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.appId,
    required this.version,
    required this.dockerCompose,
    required this.status,
    required this.lastVersion,
    required this.lastModified,
    required this.downloadUrl,
    required this.downloadCallBackUrl,
    required this.update,
    required this.ignoreUpgrade,
    required this.enable,
    required this.params,
    required this.image,
    required this.hostMode,
    required this.gpuSupport,
  });

  factory AppDeatil.fromJson(Map<String, dynamic> json) => AppDeatil(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        appId: json["appId"],
        version: json["version"],
        dockerCompose: json["dockerCompose"],
        status: json["status"],
        lastVersion: json["lastVersion"],
        lastModified: json["lastModified"],
        downloadUrl: json["downloadUrl"],
        downloadCallBackUrl: json["downloadCallBackUrl"],
        update: json["update"],
        ignoreUpgrade: json["ignoreUpgrade"],
        enable: json["enable"],
        params: Params.fromJson(json["params"]),
        image: json["image"],
        hostMode: json["hostMode"],
        gpuSupport: json["gpuSupport"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "appId": appId,
        "version": version,
        "dockerCompose": dockerCompose,
        "status": status,
        "lastVersion": lastVersion,
        "lastModified": lastModified,
        "downloadUrl": downloadUrl,
        "downloadCallBackUrl": downloadCallBackUrl,
        "update": update,
        "ignoreUpgrade": ignoreUpgrade,
        "enable": enable,
        "params": params.toJson(),
        "image": image,
        "hostMode": hostMode,
        "gpuSupport": gpuSupport,
      };
}

class Params {
  List<FormField> formFields;

  Params({
    required this.formFields,
  });

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        formFields: List<FormField>.from(
            json["formFields"].map((x) => FormField.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formFields": List<dynamic>.from(formFields.map((x) => x.toJson())),
      };
}

class FormField {
  Child? child;
  dynamic formFieldDefault;
  String envKey;
  String labelEn;
  String labelZh;
  bool required;
  String type;
  List<Value>? values;
  bool? random;
  String? rule;
  bool? edit;

  FormField({
    this.child,
    required this.formFieldDefault,
    required this.envKey,
    required this.labelEn,
    required this.labelZh,
    required this.required,
    required this.type,
    this.values,
    this.random,
    this.rule,
    this.edit,
  });

  factory FormField.fromJson(Map<String, dynamic> json) => FormField(
        child: json["child"] == null ? null : Child.fromJson(json["child"]),
        formFieldDefault: json["default"],
        envKey: json["envKey"],
        labelEn: json["labelEn"],
        labelZh: json["labelZh"],
        required: json["required"],
        type: json["type"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
        random: json["random"],
        rule: json["rule"],
        edit: json["edit"],
      );

  Map<String, dynamic> toJson() => {
        "child": child?.toJson(),
        "default": formFieldDefault,
        "envKey": envKey,
        "labelEn": labelEn,
        "labelZh": labelZh,
        "required": required,
        "type": type,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "random": random,
        "rule": rule,
        "edit": edit,
      };
}

class Child {
  String childDefault;
  String envKey;
  bool required;
  String type;

  Child({
    required this.childDefault,
    required this.envKey,
    required this.required,
    required this.type,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
        childDefault: json["default"],
        envKey: json["envKey"],
        required: json["required"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "default": childDefault,
        "envKey": envKey,
        "required": required,
        "type": type,
      };
}

class Value {
  String label;
  String value;

  Value({
    required this.label,
    required this.value,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        label: json["label"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
      };
}
