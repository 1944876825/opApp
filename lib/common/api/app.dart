import 'package:op_app/common/http/dio.dart';
import 'package:op_app/common/model/app.dart';

class ApiApp {
  // static FutureBaseRes<List<AppItem>> installedList() async {
  //   return await myDio.myFetch("/apps/installed/list", (data) {
  //     return data.map<AppItem>((e) => AppItem.fromJson(e)).toList();
  //   }, method: "get");
  // }

  static FutureBaseRes<List<AppItem>> installedSearch(Json data) async {
    return await myDio.myFetch("/apps/installed/search", (data) {
      return data["items"].map<AppItem>((e) => AppItem.fromJson(e)).toList();
    }, data: data);
  }
}
