import 'package:op_app/common/http/dio.dart';
import 'package:op_app/common/model/dashboard.dart';

class ApiDashBoard {
  static FutureBaseRes<DashBoard> baseAllAll() async {
    return await myDio.myFetch("/dashboard/base/all/all", (data) {
      return DashBoard.fromJson(data);
    }, method: "get");
  }

  static FutureBaseRes<DashBoardCurrent> current({
    String ioOption = "all",
    String netOption = "all",
    String scope = "basic",
  }) async {
    return await myDio.myFetch("/dashboard/current", (data) {
      return DashBoardCurrent.fromJson(data);
    }, data: {"ioOption": ioOption, "netOption": netOption, "scope": scope});
  }
}
