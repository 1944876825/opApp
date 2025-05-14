import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:op_app/pages/app/install.dart';

import '../../common/api/app.dart';
import '../../common/model/app.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  List<AppsItem> _appList = [];
  List<Tag> _tagList = [];
  String _tag = "all";
  int _page = 1;

  @override
  initState() {
    _getAppTags();
    super.initState();
  }

  Future _getAppList() async {
    print("mydebug $_tag $_page");
    var res = await ApiApp.appsSearch({
      "name": "",
      "page": _page,
      "pageSize": 60,
      // "recommend": true,
      "resource": "all",
      "tags": _tag.isEmpty || _tag == "all" ? [] : [_tag],
      "type": ""
    });
    if (!res.success) {
      return;
    }
    _appList = res.data!;
  }

  _getAppTags() async {
    var res = await ApiApp.appsTags();
    if (!res.success) {
      return;
    }
    _tagList = res.data!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("应用商店"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: [
                const SizedBox(),
                ..._tagList.map(
                  (e) => FilterChip(
                    label: Text(e.name),
                    selected: _tag == e.key,
                    onSelected: (b) {
                      if (b) {
                        setState(() {
                          _tag = e.key;
                          _page = 1;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getAppList(),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => InstallPage(
                                appName: app.name,
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.memory(
                              base64Decode(app.icon),
                              width: 36,
                              height: 36,
                              fit: BoxFit.fill,
                            ),
                          ),
                          title: Text(
                            app.name,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            app.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildStatus(app.installed),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildStatus(bool status) {
    Color circleColor;

    // 根据 status 选择颜色
    if (status) {
      circleColor = Colors.green;
    } else {
      circleColor = Colors.grey; // 可以给其他状态一个默认颜色
    }

    return Container(
      width: 48,
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: circleColor, width: 1),
      ),
      child: Text(
        status ? "已安装" : "安装",
        style: TextStyle(
          color: circleColor,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
