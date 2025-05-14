class WebSiteItem {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String protocol;
  String primaryDomain;
  String type;
  String alias;
  String remark;
  String status;
  String httpConfig;
  DateTime expireDate;
  String proxy;
  String proxyType;
  bool errorLog;
  bool accessLog;
  bool defaultServer;
  bool ipv6;
  String rewrite;
  int webSiteGroupId;
  int webSiteSslId;
  int runtimeId;
  int appInstallId;
  int ftpId;
  String user;
  String group;
  List<Domain> domains;
  WebSiteSsl webSiteSsl;
  String errorLogPath;
  String accessLogPath;
  String sitePath;
  String appName;
  String runtimeName;
  String siteDir;

  WebSiteItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.protocol,
    required this.primaryDomain,
    required this.type,
    required this.alias,
    required this.remark,
    required this.status,
    required this.httpConfig,
    required this.expireDate,
    required this.proxy,
    required this.proxyType,
    required this.errorLog,
    required this.accessLog,
    required this.defaultServer,
    required this.ipv6,
    required this.rewrite,
    required this.webSiteGroupId,
    required this.webSiteSslId,
    required this.runtimeId,
    required this.appInstallId,
    required this.ftpId,
    required this.user,
    required this.group,
    required this.domains,
    required this.webSiteSsl,
    required this.errorLogPath,
    required this.accessLogPath,
    required this.sitePath,
    required this.appName,
    required this.runtimeName,
    required this.siteDir,
  });

  factory WebSiteItem.fromJson(Map<String, dynamic> json) => WebSiteItem(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        protocol: json["protocol"],
        primaryDomain: json["primaryDomain"],
        type: json["type"],
        alias: json["alias"],
        remark: json["remark"],
        status: json["status"],
        httpConfig: json["httpConfig"],
        expireDate: DateTime.parse(json["expireDate"]),
        proxy: json["proxy"],
        proxyType: json["proxyType"],
        errorLog: json["errorLog"],
        accessLog: json["accessLog"],
        defaultServer: json["defaultServer"],
        ipv6: json["IPV6"],
        rewrite: json["rewrite"],
        webSiteGroupId: json["webSiteGroupId"],
        webSiteSslId: json["webSiteSSLId"],
        runtimeId: json["runtimeID"],
        appInstallId: json["appInstallId"],
        ftpId: json["ftpId"],
        user: json["user"],
        group: json["group"],
        domains:
            List<Domain>.from(json["domains"].map((x) => Domain.fromJson(x))),
        webSiteSsl: WebSiteSsl.fromJson(json["webSiteSSL"]),
        errorLogPath: json["errorLogPath"],
        accessLogPath: json["accessLogPath"],
        sitePath: json["sitePath"],
        appName: json["appName"],
        runtimeName: json["runtimeName"],
        siteDir: json["siteDir"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "protocol": protocol,
        "primaryDomain": primaryDomain,
        "type": type,
        "alias": alias,
        "remark": remark,
        "status": status,
        "httpConfig": httpConfig,
        "expireDate": expireDate.toIso8601String(),
        "proxy": proxy,
        "proxyType": proxyType,
        "errorLog": errorLog,
        "accessLog": accessLog,
        "defaultServer": defaultServer,
        "IPV6": ipv6,
        "rewrite": rewrite,
        "webSiteGroupId": webSiteGroupId,
        "webSiteSSLId": webSiteSslId,
        "runtimeID": runtimeId,
        "appInstallId": appInstallId,
        "ftpId": ftpId,
        "user": user,
        "group": group,
        "domains": List<dynamic>.from(domains.map((x) => x.toJson())),
        "webSiteSSL": webSiteSsl.toJson(),
        "errorLogPath": errorLogPath,
        "accessLogPath": accessLogPath,
        "sitePath": sitePath,
        "appName": appName,
        "runtimeName": runtimeName,
        "siteDir": siteDir,
      };
}

class Domain {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  int websiteId;
  String domain;
  int port;

  Domain({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.websiteId,
    required this.domain,
    required this.port,
  });

  factory Domain.fromJson(Map<String, dynamic> json) => Domain(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        websiteId: json["websiteId"],
        domain: json["domain"],
        port: json["port"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "websiteId": websiteId,
        "domain": domain,
        "port": port,
      };
}

class WebSiteSsl {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String primaryDomain;
  String privateKey;
  String pem;
  String domains;
  String certUrl;
  String type;
  String provider;
  String organization;
  int dnsAccountId;
  int acmeAccountId;
  int caId;
  bool autoRenew;
  DateTime expireDate;
  DateTime startDate;
  String status;
  String message;
  String keyType;
  bool pushDir;
  String dir;
  String description;
  bool skipDns;
  String nameserver1;
  String nameserver2;
  bool disableCname;
  bool execShell;
  String shell;
  AcmeAccount acmeAccount;
  DnsAccount dnsAccount;
  dynamic websites;

  WebSiteSsl({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.primaryDomain,
    required this.privateKey,
    required this.pem,
    required this.domains,
    required this.certUrl,
    required this.type,
    required this.provider,
    required this.organization,
    required this.dnsAccountId,
    required this.acmeAccountId,
    required this.caId,
    required this.autoRenew,
    required this.expireDate,
    required this.startDate,
    required this.status,
    required this.message,
    required this.keyType,
    required this.pushDir,
    required this.dir,
    required this.description,
    required this.skipDns,
    required this.nameserver1,
    required this.nameserver2,
    required this.disableCname,
    required this.execShell,
    required this.shell,
    required this.acmeAccount,
    required this.dnsAccount,
    required this.websites,
  });

  factory WebSiteSsl.fromJson(Map<String, dynamic> json) => WebSiteSsl(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        primaryDomain: json["primaryDomain"],
        privateKey: json["privateKey"],
        pem: json["pem"],
        domains: json["domains"],
        certUrl: json["certURL"],
        type: json["type"],
        provider: json["provider"],
        organization: json["organization"],
        dnsAccountId: json["dnsAccountId"],
        acmeAccountId: json["acmeAccountId"],
        caId: json["caId"],
        autoRenew: json["autoRenew"],
        expireDate: DateTime.parse(json["expireDate"]),
        startDate: DateTime.parse(json["startDate"]),
        status: json["status"],
        message: json["message"],
        keyType: json["keyType"],
        pushDir: json["pushDir"],
        dir: json["dir"],
        description: json["description"],
        skipDns: json["skipDNS"],
        nameserver1: json["nameserver1"],
        nameserver2: json["nameserver2"],
        disableCname: json["disableCNAME"],
        execShell: json["execShell"],
        shell: json["shell"],
        acmeAccount: AcmeAccount.fromJson(json["acmeAccount"]),
        dnsAccount: DnsAccount.fromJson(json["dnsAccount"]),
        websites: json["websites"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "primaryDomain": primaryDomain,
        "privateKey": privateKey,
        "pem": pem,
        "domains": domains,
        "certURL": certUrl,
        "type": type,
        "provider": provider,
        "organization": organization,
        "dnsAccountId": dnsAccountId,
        "acmeAccountId": acmeAccountId,
        "caId": caId,
        "autoRenew": autoRenew,
        "expireDate": expireDate.toIso8601String(),
        "startDate": startDate.toIso8601String(),
        "status": status,
        "message": message,
        "keyType": keyType,
        "pushDir": pushDir,
        "dir": dir,
        "description": description,
        "skipDNS": skipDns,
        "nameserver1": nameserver1,
        "nameserver2": nameserver2,
        "disableCNAME": disableCname,
        "execShell": execShell,
        "shell": shell,
        "acmeAccount": acmeAccount.toJson(),
        "dnsAccount": dnsAccount.toJson(),
        "websites": websites,
      };
}

class AcmeAccount {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String email;
  String url;
  String type;
  String eabKid;
  String eabHmacKey;
  String keyType;

  AcmeAccount({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.url,
    required this.type,
    required this.eabKid,
    required this.eabHmacKey,
    required this.keyType,
  });

  factory AcmeAccount.fromJson(Map<String, dynamic> json) => AcmeAccount(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        email: json["email"],
        url: json["url"],
        type: json["type"],
        eabKid: json["eabKid"],
        eabHmacKey: json["eabHmacKey"],
        keyType: json["keyType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "email": email,
        "url": url,
        "type": type,
        "eabKid": eabKid,
        "eabHmacKey": eabHmacKey,
        "keyType": keyType,
      };
}

class DnsAccount {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  String type;

  DnsAccount({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.type,
  });

  factory DnsAccount.fromJson(Map<String, dynamic> json) => DnsAccount(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
        "type": type,
      };
}
