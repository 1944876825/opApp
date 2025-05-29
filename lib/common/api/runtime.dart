import 'package:op_app/common/http/dio.dart';
import '../model/runtime.dart';

class ApiRuntime {
  // 搜索运行环境
  static FutureBaseRes<List<RuntimeItem>> search({
    int page = 1,
    int pageSize = 100,
    String? status,
    String? type,
  }) async {
    final Map<String, dynamic> data = {
      'page': page,
      'pageSize': pageSize,
    };
    if (status != null) data['status'] = status;
    if (type != null) data['type'] = type;
    print("mydebug search1 $data");
    return await myDio.myFetch("/runtimes/search", (data) {
      print("mydebug search $data");
      final items = data["items"];
      if (items == null || items is! List) return [];
      return items.map<RuntimeItem>((e) => RuntimeItem.fromJson(e)).toList();
    }, data: data);
  }
} 