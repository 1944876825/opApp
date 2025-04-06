import 'package:op_app/common/http/dio.dart';

import '../model/container.dart';

class ApiContainer {
  static FutureBaseRes<List<ContainerItem>> search(
      {String state = "all",
      int page = 1,
      int pageSize = 10,
      String filters = "",
      String orderBy = "created_at",
      String order = "null",
      bool excludeAppStore = false}) async {
    return await myDio.myFetch("/containers/search", (data) {
      return data["items"]
          .map<ContainerItem>((e) => ContainerItem.fromJson(e))
          .toList();
    }, data: {
      "state": state,
      "page": page,
      "pageSize": pageSize,
      "filters": filters,
      "orderBy": orderBy,
      "order": order,
      "excludeAppStore": excludeAppStore
    });
  }
}
