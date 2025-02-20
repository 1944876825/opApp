import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/config.dart';
import 'package:crypto/crypto.dart';

extension DioExtension on Dio {
  FutureBaseRes<T> myFetch<T>(
    String path,
    T Function(dynamic data) func, {
    Json? data,
    String? method,
    Map<String, dynamic>? queryParameters,
  }) async {
    // String unixTimestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String unixTimestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    // print(unixTimestamp);
    // print(cfg.apiKey);
    var token = generateToken(cfg.apiKey, unixTimestamp);
    // print("token $token");
    var headers = {"1Panel-Token": token, "1Panel-Timestamp": unixTimestamp};
    Options options = Options(headers: headers);
    // try {
    var m = method?.toLowerCase() ?? "post";
    Response resp;
    switch (m) {
      case "get":
        resp =
            await get(path, queryParameters: queryParameters, options: options);
        break;
      case "post":
        resp = await post(path,
            data: data, options: options, queryParameters: queryParameters);
        break;
      case "put":
        resp = await put(path,
            data: data, options: options, queryParameters: queryParameters);
        break;
      case "delete":
        resp = await delete(path,
            data: data, options: options, queryParameters: queryParameters);
      default:
        throw ArgumentError("Unsupported HTTP method: $m");
    }
    // print("--------------${resp.data}");
    // print(jsonEncode(resp.data));
    if (resp.statusCode != 200) {
      throw Exception("HTTP request failed with status ${resp.statusCode}");
    }
    if (resp.data == null) {
      throw Exception("请求为空");
    }
    if (resp.data is String) {
      try {
        resp.data = jsonDecode(resp.data);
      } catch (ee) {
        throw Exception("返回内容错误 ${resp.data} $ee");
      }
    }

    if (resp.data['code'] == 200) {
      if (resp.data['data'] == null) {
        return BaseRes.ok(null);
      }
      if (resp.data['data'].toString() == "") {
        return BaseRes.ok(null);
      }
      return BaseRes.ok(func(resp.data['data']));
    } else {
      return BaseRes.err<T>("${resp.data['message'] ?? resp.data}");
    }
    // } catch (e) {
    //   print("---------------------myFetch error $path $e");
    //   return BaseRes.err<T>("$e");
    // }
  }
}

Dio myDio = Dio(BaseOptions(
  baseUrl: 'http://162.14.96.87:8090/api/v1',
));

typedef Json = Map<String, dynamic>;
typedef FutureBaseRes<T> = Future<BaseRes<T>>;

class BaseRes<T> {
  final bool success;
  final String? message;
  final T? data;

  BaseRes({required this.success, required this.message, required this.data});

  static ok<T>(T data, {String? message}) {
    return BaseRes<T>(success: true, message: message, data: data);
  }

  static err<T>(String msg) {
    return BaseRes<T>(success: false, message: msg, data: null);
  }
}

String generateToken(String apiKey, String unixTimestamp) {
  String rawString = '1panel$apiKey$unixTimestamp';
  var bytes = utf8.encode(rawString);
  var digest = md5.convert(bytes);
  return digest.toString();
}
