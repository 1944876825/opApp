import 'package:op_app/common/http/dio.dart';
import 'package:op_app/common/model/database.dart';

class ApiDatabase {
  // 获取数据库列表
  static FutureBaseRes<List<DatabaseItem>> search({
    String type = "all",
    int page = 1,
    int pageSize = 10,
    String filters = "",
    String orderBy = "created_at",
    String order = "desc",
  }) async {
    return await myDio.myFetch("/databases/search", (data) {
      return data["items"]
          .map<DatabaseItem>((e) => DatabaseItem.fromJson(e))
          .toList();
    }, data: {
      "type": type,
      "page": page,
      "pageSize": pageSize,
      "filters": filters,
      "orderBy": orderBy,
      "order": order,
    });
  }

  // 获取数据库详情
  static FutureBaseRes<DatabaseItem> detail(int id) async {
    return await myDio.myFetch("/databases/$id", (data) {
      return DatabaseItem.fromJson(data);
    });
  }

  // 创建数据库
  static FutureBaseRes<void> create(Map<String, dynamic> data) async {
    return await myDio.myFetch("/databases", (data) {
      return null;
    }, data: data, method: "POST");
  }

  // 更新数据库
  static FutureBaseRes<void> update(int id, Map<String, dynamic> data) async {
    return await myDio.myFetch("/databases/$id", (data) {
      return null;
    }, data: data, method: "PUT");
  }

  // 删除数据库
  static FutureBaseRes<void> delete(int id) async {
    return await myDio.myFetch("/databases/$id", (data) {
      return null;
    }, method: "DELETE");
  }

  // 启动数据库
  static FutureBaseRes<void> start(int id) async {
    return await myDio.myFetch("/databases/$id/start", (data) {
      return null;
    }, method: "POST");
  }

  // 停止数据库
  static FutureBaseRes<void> stop(int id) async {
    return await myDio.myFetch("/databases/$id/stop", (data) {
      return null;
    }, method: "POST");
  }

  // 重启数据库
  static FutureBaseRes<void> restart(int id) async {
    return await myDio.myFetch("/databases/$id/restart", (data) {
      return null;
    }, method: "POST");
  }
} 