import 'package:op_app/common/http/dio.dart';
import 'package:op_app/common/model/app.dart';

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
    return await myDio.myFetch("/apps/$name", (data) {
      return AppInfo.fromJson(data);
    });
  }

  static FutureBaseRes<AppDeatil> appDeatil(String appId, version) async {
    return await myDio.myFetch("/apps/detail/$appId/$version/app", (data) {
      return AppDeatil.fromJson(data);
    });
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
