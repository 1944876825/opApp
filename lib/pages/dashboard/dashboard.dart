import 'dart:async';

import 'package:flutter/material.dart';
import 'package:op_app/common/widget/animated_circular_progress.dart';

import '../../common/api/dashboard.dart';
import '../../common/model/dashboard.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  late final Future _init = () async {
    await _getBase();
  }();

  @override
  initState() {
    // _getCurrent();
    super.initState();
    _startTimer();
  }

  bool _isActive = true;

  void _startTimer() async {
    if (_isActive) {
      await _getCurrent();
    }
    print("1s后继续执行");
    await Future.delayed(Duration(seconds: 1));
    _startTimer();
  }

  late final DashBoard _baseInfo;
  _getBase() async {
    var res = await ApiDashBoard.baseAllAll();
    if (!res.success) {
      return;
    }
    setState(() {
      _baseInfo = res.data!;
    });
  }

  DashBoardCurrent? _dashBoardCurrent;
  List<double> _status = [0, 0, 0, 0];
  _getCurrent() async {
    var res = await ApiDashBoard.current();
    if (!res.success) {
      return;
    }
    _dashBoardCurrent = res.data!;
    _status = [
      _dashBoardCurrent!.cpuUsedPercent / 100,
      _dashBoardCurrent!.memoryUsedPercent / 100,
      _dashBoardCurrent!.loadUsagePercent / 100,
      _dashBoardCurrent!.diskData[0].usedPercent / 100,
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("仪表盘"),
      ),
      body: FutureBuilder(
          future: _init,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              return Center(
                child: Text(snap.error.toString()),
              );
            }
            return Column(
              children: [
                Card(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "概况",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildWebCard(
                                  "网站", _baseInfo.websiteNumber.toString()),
                              _buildWebCard(
                                  "数据库", _baseInfo.databaseNumber.toString()),
                              _buildWebCard(
                                  "任务", _baseInfo.cronjobNumber.toString()),
                              _buildWebCard("应用",
                                  _baseInfo.appInstalledNumber.toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "状态",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CpuUsageIndicator(
                                  usage: _status[0], label: "CPU"),
                              CpuUsageIndicator(usage: _status[1], label: "内存"),
                              CpuUsageIndicator(usage: _status[2], label: "负载"),
                              CpuUsageIndicator(usage: _status[3], label: "磁盘"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(),
                          Text(
                            "系统信息",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          _buildSystemInfo("主机名称", _baseInfo.hostname),
                          _buildSystemInfo("发行版本", _baseInfo.platform),
                          _buildSystemInfo("内核版本", _baseInfo.kernelVersion),
                          _buildSystemInfo("系统类型", _baseInfo.kernelArch),
                          _buildSystemInfo("主机地址", _baseInfo.ipv4Addr),
                          _buildSystemInfo("CPU类型", _baseInfo.cpuModelName),
                          _buildSystemInfo("启动时间", "2024-12-11 21:40:06"),
                          _buildSystemInfo("运行时间", "70天 22小时 39分钟 24秒"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  _buildSystemInfo(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  _buildWebCard(String label, String value) {
    return SizedBox(
      width: 50,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class CpuUsageIndicator extends StatelessWidget {
  final double usage; // 0.0 - 1.0
  final String label;

  const CpuUsageIndicator(
      {super.key, required this.usage, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: AnimatedCircularProgress(
                progress: usage,
                progressColor: Theme.of(context).colorScheme.primary,
                backgroundColor: Colors.grey[300],
                strokeWidth: 4,
              ),
            ),
            Text(
              "${(usage * 100).toStringAsFixed(1)}%", // 显示百分比
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
