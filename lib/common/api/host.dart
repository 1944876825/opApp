import '../http/dio.dart';
import '../model/host.dart';

class ApiHost {
  static FutureBaseRes<List<Host>> getList() async {
    return myDio.myFetch<List<Host>>(
      '/hosts',
      (data) => (data as List).map((e) => Host.fromJson(e)).toList(),
      method: 'get',
    );
  }

  static FutureBaseRes<Host> getDetail(int id) async {
    return myDio.myFetch<Host>(
      '/hosts/$id',
      (data) => Host.fromJson(data),
      method: 'get',
    );
  }

  static FutureBaseRes<Host> create(Map<String, dynamic> data) async {
    return myDio.myFetch<Host>(
      '/hosts',
      (data) => Host.fromJson(data),
      data: data,
      method: 'post',
    );
  }

  static FutureBaseRes<Host> update(int id, Map<String, dynamic> data) async {
    return myDio.myFetch<Host>(
      '/hosts/$id',
      (data) => Host.fromJson(data),
      data: data,
      method: 'put',
    );
  }

  static FutureBaseRes<void> delete(int id) async {
    return myDio.myFetch<void>(
      '/hosts/$id',
      (data) => null,
      method: 'delete',
    );
  }

  static FutureBaseRes<HostStatus> checkStatus(int id) async {
    return myDio.myFetch<HostStatus>(
      '/hosts/$id/status',
      (data) => HostStatus.fromJson(data),
      method: 'get',
    );
  }

  static FutureBaseRes<HostStatus> testConnection(Map<String, dynamic> data) async {
    return myDio.myFetch<HostStatus>(
      '/hosts/test',
      (data) => HostStatus.fromJson(data),
      data: data,
      method: 'post',
    );
  }
} 