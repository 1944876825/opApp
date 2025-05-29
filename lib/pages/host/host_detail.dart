import 'package:flutter/material.dart';
import '../../common/api/host.dart';
import '../../common/model/host.dart';

class HostDetailPage extends StatefulWidget {
  final Host host;

  const HostDetailPage({super.key, required this.host});

  @override
  State<HostDetailPage> createState() => _HostDetailPageState();
}

class _HostDetailPageState extends State<HostDetailPage> {
  bool _loading = false;
  String? _error;
  HostStatus? _status;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiHost.checkStatus(widget.host.id);
      if (res.success && res.data != null) {
        setState(() {
          _status = res.data;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取状态失败';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主机详情'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _checkStatus,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoCard(),
                      SizedBox(height: 16),
                      _buildStatusCard(),
                      if (_status?.data != null) ...[
                        SizedBox(height: 16),
                        _buildResourceCard(),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '基本信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('名称', widget.host.name),
            _buildInfoRow('地址', '${widget.host.address}:${widget.host.port}'),
            _buildInfoRow('用户名', widget.host.username),
            _buildInfoRow('类型', widget.host.type),
            if (widget.host.description.isNotEmpty)
              _buildInfoRow('描述', widget.host.description),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '连接状态',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('状态', _status?.status ?? '未知'),
            _buildInfoRow('消息', _status?.message ?? ''),
            _buildInfoRow('最后检查', widget.host.lastCheck),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard() {
    final data = _status!.data!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '资源使用',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (data['cpu'] != null)
              _buildInfoRow('CPU使用率', '${data['cpu']}%'),
            if (data['memory'] != null)
              _buildInfoRow('内存使用率', '${data['memory']}%'),
            if (data['disk'] != null)
              _buildInfoRow('磁盘使用率', '${data['disk']}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
} 