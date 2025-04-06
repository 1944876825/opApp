class DashBoard {
  int websiteNumber;
  int databaseNumber;
  int cronjobNumber;
  int appInstalledNumber;
  String hostname;
  String os;
  String platform;
  String platformFamily;
  String platformVersion;
  String kernelArch;
  String kernelVersion;
  String virtualizationSystem;
  String ipv4Addr;
  String systemProxy;
  int cpuCores;
  int cpuLogicalCores;
  String cpuModelName;
  CurrentInfo currentInfo;

  DashBoard({
    required this.websiteNumber,
    required this.databaseNumber,
    required this.cronjobNumber,
    required this.appInstalledNumber,
    required this.hostname,
    required this.os,
    required this.platform,
    required this.platformFamily,
    required this.platformVersion,
    required this.kernelArch,
    required this.kernelVersion,
    required this.virtualizationSystem,
    required this.ipv4Addr,
    required this.systemProxy,
    required this.cpuCores,
    required this.cpuLogicalCores,
    required this.cpuModelName,
    required this.currentInfo,
  });

  factory DashBoard.fromJson(Map<String, dynamic> json) => DashBoard(
        websiteNumber: json["websiteNumber"],
        databaseNumber: json["databaseNumber"],
        cronjobNumber: json["cronjobNumber"],
        appInstalledNumber: json["appInstalledNumber"],
        hostname: json["hostname"],
        os: json["os"],
        platform: json["platform"],
        platformFamily: json["platformFamily"],
        platformVersion: json["platformVersion"],
        kernelArch: json["kernelArch"],
        kernelVersion: json["kernelVersion"],
        virtualizationSystem: json["virtualizationSystem"],
        ipv4Addr: json["ipv4Addr"],
        systemProxy: json["SystemProxy"],
        cpuCores: json["cpuCores"],
        cpuLogicalCores: json["cpuLogicalCores"],
        cpuModelName: json["cpuModelName"],
        currentInfo: CurrentInfo.fromJson(json["currentInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "websiteNumber": websiteNumber,
        "databaseNumber": databaseNumber,
        "cronjobNumber": cronjobNumber,
        "appInstalledNumber": appInstalledNumber,
        "hostname": hostname,
        "os": os,
        "platform": platform,
        "platformFamily": platformFamily,
        "platformVersion": platformVersion,
        "kernelArch": kernelArch,
        "kernelVersion": kernelVersion,
        "virtualizationSystem": virtualizationSystem,
        "ipv4Addr": ipv4Addr,
        "SystemProxy": systemProxy,
        "cpuCores": cpuCores,
        "cpuLogicalCores": cpuLogicalCores,
        "cpuModelName": cpuModelName,
        "currentInfo": currentInfo.toJson(),
      };
}

class CurrentInfo {
  int uptime;
  String timeSinceUptime;
  int procs;
  int load1;
  int load5;
  int load15;
  int loadUsagePercent;
  dynamic cpuPercent;
  int cpuUsedPercent;
  int cpuUsed;
  int cpuTotal;
  int memoryTotal;
  int memoryAvailable;
  int memoryUsed;
  int memoryUsedPercent;
  int swapMemoryTotal;
  int swapMemoryAvailable;
  int swapMemoryUsed;
  int swapMemoryUsedPercent;
  int ioReadBytes;
  int ioWriteBytes;
  int ioCount;
  int ioReadTime;
  int ioWriteTime;
  dynamic diskData;
  int netBytesSent;
  int netBytesRecv;
  dynamic gpuData;
  dynamic xpuData;
  DateTime shotTime;

  CurrentInfo({
    required this.uptime,
    required this.timeSinceUptime,
    required this.procs,
    required this.load1,
    required this.load5,
    required this.load15,
    required this.loadUsagePercent,
    required this.cpuPercent,
    required this.cpuUsedPercent,
    required this.cpuUsed,
    required this.cpuTotal,
    required this.memoryTotal,
    required this.memoryAvailable,
    required this.memoryUsed,
    required this.memoryUsedPercent,
    required this.swapMemoryTotal,
    required this.swapMemoryAvailable,
    required this.swapMemoryUsed,
    required this.swapMemoryUsedPercent,
    required this.ioReadBytes,
    required this.ioWriteBytes,
    required this.ioCount,
    required this.ioReadTime,
    required this.ioWriteTime,
    required this.diskData,
    required this.netBytesSent,
    required this.netBytesRecv,
    required this.gpuData,
    required this.xpuData,
    required this.shotTime,
  });

  factory CurrentInfo.fromJson(Map<String, dynamic> json) => CurrentInfo(
        uptime: json["uptime"],
        timeSinceUptime: json["timeSinceUptime"],
        procs: json["procs"],
        load1: json["load1"],
        load5: json["load5"],
        load15: json["load15"],
        loadUsagePercent: json["loadUsagePercent"],
        cpuPercent: json["cpuPercent"],
        cpuUsedPercent: json["cpuUsedPercent"],
        cpuUsed: json["cpuUsed"],
        cpuTotal: json["cpuTotal"],
        memoryTotal: json["memoryTotal"],
        memoryAvailable: json["memoryAvailable"],
        memoryUsed: json["memoryUsed"],
        memoryUsedPercent: json["memoryUsedPercent"],
        swapMemoryTotal: json["swapMemoryTotal"],
        swapMemoryAvailable: json["swapMemoryAvailable"],
        swapMemoryUsed: json["swapMemoryUsed"],
        swapMemoryUsedPercent: json["swapMemoryUsedPercent"],
        ioReadBytes: json["ioReadBytes"],
        ioWriteBytes: json["ioWriteBytes"],
        ioCount: json["ioCount"],
        ioReadTime: json["ioReadTime"],
        ioWriteTime: json["ioWriteTime"],
        diskData: json["diskData"],
        netBytesSent: json["netBytesSent"],
        netBytesRecv: json["netBytesRecv"],
        gpuData: json["gpuData"],
        xpuData: json["xpuData"],
        shotTime: DateTime.parse(json["shotTime"]),
      );

  Map<String, dynamic> toJson() => {
        "uptime": uptime,
        "timeSinceUptime": timeSinceUptime,
        "procs": procs,
        "load1": load1,
        "load5": load5,
        "load15": load15,
        "loadUsagePercent": loadUsagePercent,
        "cpuPercent": cpuPercent,
        "cpuUsedPercent": cpuUsedPercent,
        "cpuUsed": cpuUsed,
        "cpuTotal": cpuTotal,
        "memoryTotal": memoryTotal,
        "memoryAvailable": memoryAvailable,
        "memoryUsed": memoryUsed,
        "memoryUsedPercent": memoryUsedPercent,
        "swapMemoryTotal": swapMemoryTotal,
        "swapMemoryAvailable": swapMemoryAvailable,
        "swapMemoryUsed": swapMemoryUsed,
        "swapMemoryUsedPercent": swapMemoryUsedPercent,
        "ioReadBytes": ioReadBytes,
        "ioWriteBytes": ioWriteBytes,
        "ioCount": ioCount,
        "ioReadTime": ioReadTime,
        "ioWriteTime": ioWriteTime,
        "diskData": diskData,
        "netBytesSent": netBytesSent,
        "netBytesRecv": netBytesRecv,
        "gpuData": gpuData,
        "xpuData": xpuData,
        "shotTime": shotTime.toIso8601String(),
      };
}

class DashBoardCurrent {
  int uptime;
  DateTime timeSinceUptime;
  int procs;
  double load1;
  double load5;
  double load15;
  double loadUsagePercent;
  List<double> cpuPercent;
  double cpuUsedPercent;
  double cpuUsed;
  int cpuTotal;
  int memoryTotal;
  int memoryAvailable;
  int memoryUsed;
  double memoryUsedPercent;
  int swapMemoryTotal;
  int swapMemoryAvailable;
  int swapMemoryUsed;
  int swapMemoryUsedPercent;
  int ioReadBytes;
  int ioWriteBytes;
  int ioCount;
  int ioReadTime;
  int ioWriteTime;
  List<DiskDatum> diskData;
  int netBytesSent;
  int netBytesRecv;
  dynamic gpuData;
  dynamic xpuData;
  DateTime shotTime;

  DashBoardCurrent({
    required this.uptime,
    required this.timeSinceUptime,
    required this.procs,
    required this.load1,
    required this.load5,
    required this.load15,
    required this.loadUsagePercent,
    required this.cpuPercent,
    required this.cpuUsedPercent,
    required this.cpuUsed,
    required this.cpuTotal,
    required this.memoryTotal,
    required this.memoryAvailable,
    required this.memoryUsed,
    required this.memoryUsedPercent,
    required this.swapMemoryTotal,
    required this.swapMemoryAvailable,
    required this.swapMemoryUsed,
    required this.swapMemoryUsedPercent,
    required this.ioReadBytes,
    required this.ioWriteBytes,
    required this.ioCount,
    required this.ioReadTime,
    required this.ioWriteTime,
    required this.diskData,
    required this.netBytesSent,
    required this.netBytesRecv,
    required this.gpuData,
    required this.xpuData,
    required this.shotTime,
  });

  factory DashBoardCurrent.fromJson(Map<String, dynamic> json) =>
      DashBoardCurrent(
        uptime: json["uptime"],
        timeSinceUptime: DateTime.parse(json["timeSinceUptime"]),
        procs: json["procs"],
        load1: json["load1"]?.toDouble(),
        load5: json["load5"]?.toDouble(),
        load15: json["load15"]?.toDouble(),
        loadUsagePercent: json["loadUsagePercent"]?.toDouble(),
        cpuPercent:
            List<double>.from(json["cpuPercent"].map((x) => x.toDouble())),
        cpuUsedPercent: json["cpuUsedPercent"].toDouble(),
        cpuUsed: json["cpuUsed"].toDouble(),
        cpuTotal: json["cpuTotal"],
        memoryTotal: json["memoryTotal"],
        memoryAvailable: json["memoryAvailable"],
        memoryUsed: json["memoryUsed"],
        memoryUsedPercent: json["memoryUsedPercent"]?.toDouble(),
        swapMemoryTotal: json["swapMemoryTotal"],
        swapMemoryAvailable: json["swapMemoryAvailable"],
        swapMemoryUsed: json["swapMemoryUsed"],
        swapMemoryUsedPercent: json["swapMemoryUsedPercent"],
        ioReadBytes: json["ioReadBytes"],
        ioWriteBytes: json["ioWriteBytes"],
        ioCount: json["ioCount"],
        ioReadTime: json["ioReadTime"],
        ioWriteTime: json["ioWriteTime"],
        diskData: List<DiskDatum>.from(
            json["diskData"].map((x) => DiskDatum.fromJson(x))),
        netBytesSent: json["netBytesSent"],
        netBytesRecv: json["netBytesRecv"],
        gpuData: json["gpuData"],
        xpuData: json["xpuData"],
        shotTime: DateTime.parse(json["shotTime"]),
      );

  Map<String, dynamic> toJson() => {
        "uptime": uptime,
        "timeSinceUptime": timeSinceUptime.toIso8601String(),
        "procs": procs,
        "load1": load1,
        "load5": load5,
        "load15": load15,
        "loadUsagePercent": loadUsagePercent,
        "cpuPercent": List<dynamic>.from(cpuPercent.map((x) => x)),
        "cpuUsedPercent": cpuUsedPercent,
        "cpuUsed": cpuUsed,
        "cpuTotal": cpuTotal,
        "memoryTotal": memoryTotal,
        "memoryAvailable": memoryAvailable,
        "memoryUsed": memoryUsed,
        "memoryUsedPercent": memoryUsedPercent,
        "swapMemoryTotal": swapMemoryTotal,
        "swapMemoryAvailable": swapMemoryAvailable,
        "swapMemoryUsed": swapMemoryUsed,
        "swapMemoryUsedPercent": swapMemoryUsedPercent,
        "ioReadBytes": ioReadBytes,
        "ioWriteBytes": ioWriteBytes,
        "ioCount": ioCount,
        "ioReadTime": ioReadTime,
        "ioWriteTime": ioWriteTime,
        "diskData": List<dynamic>.from(diskData.map((x) => x.toJson())),
        "netBytesSent": netBytesSent,
        "netBytesRecv": netBytesRecv,
        "gpuData": gpuData,
        "xpuData": xpuData,
        "shotTime": shotTime.toIso8601String(),
      };
}

class DiskDatum {
  String path;
  String type;
  String device;
  int total;
  int free;
  int used;
  double usedPercent;
  int inodesTotal;
  int inodesUsed;
  int inodesFree;
  double inodesUsedPercent;

  DiskDatum({
    required this.path,
    required this.type,
    required this.device,
    required this.total,
    required this.free,
    required this.used,
    required this.usedPercent,
    required this.inodesTotal,
    required this.inodesUsed,
    required this.inodesFree,
    required this.inodesUsedPercent,
  });

  factory DiskDatum.fromJson(Map<String, dynamic> json) => DiskDatum(
        path: json["path"],
        type: json["type"],
        device: json["device"],
        total: json["total"],
        free: json["free"],
        used: json["used"],
        usedPercent: json["usedPercent"]?.toDouble(),
        inodesTotal: json["inodesTotal"],
        inodesUsed: json["inodesUsed"],
        inodesFree: json["inodesFree"],
        inodesUsedPercent: json["inodesUsedPercent"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
        "device": device,
        "total": total,
        "free": free,
        "used": used,
        "usedPercent": usedPercent,
        "inodesTotal": inodesTotal,
        "inodesUsed": inodesUsed,
        "inodesFree": inodesFree,
        "inodesUsedPercent": inodesUsedPercent,
      };
}
