class ContainerItem {
  String containerId;
  String name;
  String imageId;
  String imageName;
  DateTime createTime;
  String state;
  String runTime;
  List<String> network;
  List<String> ports;
  bool isFromApp;
  bool isFromCompose;
  String appName;
  String appInstallName;
  dynamic websites;

  ContainerItem({
    required this.containerId,
    required this.name,
    required this.imageId,
    required this.imageName,
    required this.createTime,
    required this.state,
    required this.runTime,
    required this.network,
    required this.ports,
    required this.isFromApp,
    required this.isFromCompose,
    required this.appName,
    required this.appInstallName,
    required this.websites,
  });

  factory ContainerItem.fromJson(Map<String, dynamic> json) => ContainerItem(
        containerId: json["containerID"],
        name: json["name"],
        imageId: json["imageID"],
        imageName: json["imageName"],
        createTime: DateTime.parse(json["createTime"]),
        state: json["state"],
        runTime: json["runTime"],
        network:
            json["network"]?.map<String>((x) => x.toString()).toList() ?? [],
        ports: json["ports"]?.map<String>((x) => x.toString()).toList() ?? [],
        isFromApp: json["isFromApp"],
        isFromCompose: json["isFromCompose"],
        appName: json["appName"],
        appInstallName: json["appInstallName"],
        websites: json["websites"],
      );

  Map<String, dynamic> toJson() => {
        "containerID": containerId,
        "name": name,
        "imageID": imageId,
        "imageName": imageName,
        "createTime": createTime.toIso8601String(),
        "state": state,
        "runTime": runTime,
        "network": List<dynamic>.from(network.map((x) => x)),
        "ports": List<dynamic>.from(ports.map((x) => x)),
        "isFromApp": isFromApp,
        "isFromCompose": isFromCompose,
        "appName": appName,
        "appInstallName": appInstallName,
        "websites": websites,
      };
}
