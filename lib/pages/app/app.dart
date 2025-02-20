import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:op_app/common/api/app.dart';
import 'package:op_app/common/model/app.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  List<AppItem> _appList = [];
  late final Future _init = () async {
    await _getAppList();
  }();

  _getAppList() async {
    var res = await ApiApp.installedSearch({
      "all": true,
      "name": "",
      "page": 1,
      "pageSize": 20,
      "sync": true,
      "tags": [],
      "type": "",
      "unused": true,
      "update": true
    });
    if (!res.success) {
      return;
    }
    _appList = res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("应用商店"),
        // centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: FutureBuilder(
          future: _init,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              return Center(
                child: Text(snap.error.toString()),
              );
            }
            return ListView.builder(
              itemCount: _appList.length,
              itemBuilder: (context, index) {
                var app = _appList[index];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.memory(
                        base64Decode(app.icon),
                        width: 48,
                        height: 48,
                        fit: BoxFit.fill,
                      ),
                    ),
                    title: Text(
                      app.appName,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      app.version,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatus(app.status),
                        const SizedBox(width: 5),
                        Text(app.status),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }

  _buildStatus(String status) {
    Color circleColor;

    // 根据 status 选择颜色
    if (status == "Running") {
      circleColor = Colors.green;
    } else if (status == "Stopped") {
      circleColor = Colors.grey;
    } else {
      circleColor = Colors.orange; // 可以给其他状态一个默认颜色
    }

    return Container(
      width: 8, // 圆形直径
      height: 8,
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle, // 让 Container 变成圆形
      ),
    );
  }
}
