import 'dart:async';

import 'package:flutter/material.dart';
import 'package:op_app/common/widget/animated_circular_progress.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:op_app/common/widgets/message.dart';
import 'package:op_app/pages/container/container.dart';
import 'package:op_app/pages/host/host_list.dart';
import 'package:op_app/pages/ssh/ssh_terminal.dart';

import '../../common/api/dashboard.dart';
import '../../common/model/dashboard.dart';
import '../../common/model/website.dart';
import '../web/web_file_manager.dart';
import '../container/container.dart';
import '../host/host_list.dart';
import '../ssh/ssh_terminal.dart';

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
    super.initState();
    _startTimer();
  }

  bool _isActive = true;

  void _startTimer() async {
    if (_isActive) {
      await _getCurrent();
    }
    await Future.delayed(Duration(seconds: 1));
    _startTimer();
  }

  late final DashBoard _baseInfo;
  _getBase() async {
    var res = await ApiDashboard.baseAllAll();
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
    var res = await ApiDashboard.current();
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
        title: const Text('仪表盘'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _getBase();
              _getCurrent();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // 根据屏幕宽度决定布局
          final isLargeScreen = constraints.maxWidth > 1200;
          final isMediumScreen = constraints.maxWidth > 800;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLargeScreen)
                  // 大屏幕布局：两列
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildSystemToolsCard(isLargeScreen),
                            const SizedBox(height: 24),
                            _buildSystemInfoCard(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        flex: 3,
                        child: _buildResourceUsageCard(),
                      ),
                    ],
                  )
                else
                  // 小屏幕布局：单列
                  Column(
                    children: [
                      _buildSystemToolsCard(isLargeScreen),
                      const SizedBox(height: 16),
                      _buildSystemInfoCard(),
                      const SizedBox(height: 16),
                      _buildResourceUsageCard(),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSystemToolsCard(bool isLargeScreen) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '系统工具',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isLargeScreen ? 4 : 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: isLargeScreen ? 1.2 : 1.0,
              children: [
                _buildToolCard(
                  context,
                  '容器管理',
                  Icons.dock,
                  Theme.of(context).colorScheme.primary,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContainerPage(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  '主机管理',
                  Icons.computer,
                  Theme.of(context).colorScheme.primary,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HostListPage(),
                    ),
                  ),
                ),
                _buildToolCard(
                  context,
                  '终端',
                  Icons.terminal,
                  Theme.of(context).colorScheme.primary,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SSHTerminalPage(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '系统信息',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('主机名', _baseInfo.hostname),
            _buildInfoRow('平台', _baseInfo.platform),
            _buildInfoRow('内核版本', _baseInfo.kernelVersion),
            _buildInfoRow('运行时间', _baseInfo.currentInfo.timeSinceUptime),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceUsageCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '资源使用',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildResourceUsage(
              'CPU',
              _dashBoardCurrent?.cpuUsedPercent ?? 0,
              Theme.of(context).colorScheme.primary,
              '${_dashBoardCurrent?.cpuUsedPercent.toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 12),
            _buildResourceUsage(
              '内存',
              _dashBoardCurrent?.memoryUsedPercent ?? 0,
              Theme.of(context).colorScheme.primary,
              '${_dashBoardCurrent?.memoryUsedPercent.toStringAsFixed(1)}%',
            ),
            const SizedBox(height: 12),
            _buildResourceUsage(
              '磁盘',
              _dashBoardCurrent?.diskData.isNotEmpty == true 
                ? _dashBoardCurrent!.diskData[0].usedPercent 
                : 0,
              Theme.of(context).colorScheme.primary,
              _dashBoardCurrent?.diskData.isNotEmpty == true 
                ? '${_dashBoardCurrent!.diskData[0].usedPercent.toStringAsFixed(1)}%'
                : '0%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceUsage(
    String label,
    double percentage,
    Color color,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
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
              "${(usage * 100).toStringAsFixed(1)}%",
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
