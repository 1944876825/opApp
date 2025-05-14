import 'package:op_app/common/http/dio.dart';

import '../model/websites.dart';

class ApiWebsites {
  static FutureBaseRes<List<WebSiteItem>> getList(
      {String state = "all",
      int page = 1,
      int pageSize = 10,
      String filters = "",
      String orderBy = "created_at",
      String order = "null",
      bool excludeAppStore = false}) async {
    return await myDio.myFetch("/websites/list", (data) {
      return data.map<WebSiteItem>((e) => WebSiteItem.fromJson(e)).toList();
    }, method: "GET");
  }
}
