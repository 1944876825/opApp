import 'package:op_app/common/http/dio.dart';
import 'package:op_app/common/model/app.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:op_app/common/config/config.dart';

class ApiApp {
  // static FutureBaseRes<List<AppItem>> installedList() async {
  //   return await myDio.myFetch("/apps/installed/list", (data) {
  //     return data.map<AppItem>((e) => AppItem.fromJson(e)).toList();
  //   }, method: "get");
  // }
  // 已安装应用搜索
  static FutureBaseRes<List<AppItem>> installedSearch(Json data) async {
    return await myDio.myFetch("/apps/installed/search", (data) {
      return data["items"].map<AppItem>((e) => AppItem.fromJson(e)).toList();
    }, data: data);
  }

  // 应用商城搜索
  static FutureBaseRes<List<AppsItem>> appsSearch(Json data) async {
    return await myDio.myFetch("/apps/search", (data) {
      print("mydebug appsSearch $data");
      return data["items"].map<AppsItem>((e) => AppsItem.fromJson(e)).toList();
    }, data: data);
  }

  // Tags
  static FutureBaseRes<List<Tag>> appsTags() async {
    // return await myDio.myFetch("/apps/tags", (data) {
    //   return data.map<TagItem>((e) => TagItem.fromJson(e)).toList();
    // });
    return BaseRes.ok<List<Tag>>(
        tags.map<Tag>((e) => Tag.fromJson(e)).toList());
  }

  // 应用详情
  static FutureBaseRes<AppInfo> appInfo(String name) async {
    print("mydebug /apps/$name");
    return await myDio.myFetch("/apps/$name", (data) {
      print("mydebug data $data");
      return AppInfo.fromJson(data);
    }, method: "get");
  }

  static FutureBaseRes<AppDeatil> appDeatil(String appId, version) async {
    print("mydebug /apps/detail/$appId/$version/app");
    return await myDio.myFetch("/apps/detail/$appId/$version/app", (data) {
      print("mydebug data $data");
      return AppDeatil.fromJson(data);
    }, method: "get");
  }

  static FutureBaseRes<void> start(String id) async {
    return await myDio.myFetch(
      '/apps/start',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<void> stop(String id) async {
    return await myDio.myFetch(
      '/apps/stop',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<void> update(String id) async {
    return await myDio.myFetch(
      '/apps/update',
      (data) => null,
      data: {'id': id},
      method: 'POST',
    );
  }

  static FutureBaseRes<void> uninstall(String id) async {
    return await myDio.myFetch(
      '/apps/installed/op',
      (data) => null,
      data: {
        'operate': 'delete',
        'installId': int.parse(id),
        'deleteBackup': true,
        'forceDelete': true,
        'deleteDB': true
      },
      method: 'POST',
    );
  }

  static FutureBaseRes<void> install(Map<String, dynamic> data) {
    return myDio.myFetch<void>(
      '/apps/install',
      (data) => null,
      data: data,
      method: 'POST',
    );
  }

  static FutureBaseRes<String> installLog(String name) async {
    return await myDio.myFetch("/apps/install/log/$name", (data) {
      return data.toString();
    });
  }

  static Stream<String> getRealtimeLog(String composePath) {
    final wsUrl = 'ws://162.14.96.87:8090/api/v1/containers/compose/search/log';
    final unixTimestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final token = generateToken(cfg.apiKey, unixTimestamp);
    
    final params = {
      'compose': composePath,
      'since': (DateTime.now().millisecondsSinceEpoch / 1000).toString(),
      'tail': '200',
      'follow': 'true',
      'token': token,
      'timestamp': unixTimestamp
    };
    
    final uri = Uri.parse(wsUrl).replace(queryParameters: params);
    final channel = WebSocketChannel.connect(uri);
    
    return channel.stream.map((data) {
      if (data is String) {
        return data;
      } else if (data is List<int>) {
        return String.fromCharCodes(data);
      } else {
        return data.toString();
      }
    });
  }

  static FutureBaseRes<List<ServiceItem>> services(String key) async {
    print("mydebug /apps/services/$key");
    return await myDio.myFetch("/apps/services/$key", (data) {
      print("mydebug services data $data");
      return data.map<ServiceItem>((e) => ServiceItem.fromJson(e)).toList();
    }, method: "get");
  }
}

const tags = [
  {"id": -1, "key": "all", "name": "全部"},
  {"id": 1601, "key": "Website", "name": "建站"},
  {"id": 1602, "key": "Database", "name": "数据库"},
  {"id": 1603, "key": "Server", "name": "Web 服务器"},
  {"id": 1604, "key": "Runtime", "name": "运行环境"},
  {"id": 1605, "key": "Tool", "name": "实用工具"},
  {"id": 1606, "key": "Storage", "name": "云存储"},
  {"id": 1607, "key": "AI", "name": "AI / 大模型"},
  {"id": 1608, "key": "BI", "name": "BI"},
  {"id": 1609, "key": "Security", "name": "安全"},
  {"id": 1610, "key": "DevTool", "name": "开发工具"},
  {"id": 1611, "key": "DevOps", "name": "DevOps"},
  {"id": 1612, "key": "Middleware", "name": "中间件"},
  {"id": 1613, "key": "Media", "name": "多媒体"},
  {"id": 1614, "key": "Email", "name": "邮件服务"},
  {"id": 1615, "key": "Game", "name": "休闲游戏"},
  {"id": 1616, "key": "Local", "name": "本地"}
];
