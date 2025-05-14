import 'package:flutter/material.dart';
import 'package:op_app/common/model/app.dart';

import '../../common/api/app.dart';

class InstallPage extends StatefulWidget {
  final String appName;
  const InstallPage({super.key, required this.appName});

  @override
  State<InstallPage> createState() => _InstallPageState();
}

class _InstallPageState extends State<InstallPage> {
  @override
  initState() {
    init();
    super.initState();
  }

  init() async {
    await _getAppInfo();
    await _getAppDetail(appInfo.id.toString(), appInfo.versions.first);
  }

  late final AppInfo appInfo;
  _getAppInfo() async {
    var res = await ApiApp.appInfo(widget.appName);
    if (!res.success) {
      return;
    }
    appInfo = res.data!;
    setState(() {});
  }

  AppDeatil? appDeatil;
  _getAppDetail(String appId, version) async {
    var res = await ApiApp.appDeatil(appId, version);
    if (!res.success) {
      return;
    }
    appDeatil = res.data;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("安装"),
      ),
      body: Column(
        children: _buildForm(),
      ),
    );
  }

  _buildForm() {
    List<Widget> forms = [];
    forms.add(TextFormField(
      decoration: const InputDecoration(
        labelText: "应用名称",
      ),
    ));
    forms.add(TextFormField(
      decoration: const InputDecoration(
        labelText: "应用版本",
      ),
      // initialValue: appInfo.versions.first,
    ));
    // appDeatil.params.formFields.map((e)=>{

    // })
    return forms;
  }
}
