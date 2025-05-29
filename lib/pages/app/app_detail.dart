import 'package:flutter/material.dart';
import 'package:op_app/common/api/app.dart';
import 'package:op_app/common/model/app.dart';
import 'dart:convert';

class AppDetailPage extends StatefulWidget {
  final AppItem app;

  const AppDetailPage({super.key, required this.app});

  @override
  State<AppDetailPage> createState() => _AppDetailPageState();
}

class _AppDetailPageState extends State<AppDetailPage> {
  bool _loading = false;
  String? _error;

  Future<void> _startApp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiApp.start(widget.app.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('启动成功')),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = res.message ?? '启动失败';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _stopApp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiApp.stop(widget.app.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('停止成功')),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = res.message ?? '停止失败';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _updateApp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiApp.update(widget.app.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新成功')),
        );
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = res.message ?? '更新失败';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _uninstallApp() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认卸载'),
        content: Text('确定要卸载 ${widget.app.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('卸载', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _loading = true;
        _error = null;
      });

      try {
        final res = await ApiApp.uninstall(widget.app.id.toString());
        if (res.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('卸载成功')),
          );
          Navigator.pop(context, true);
        } else {
          setState(() {
            _error = res.message ?? '卸载失败';
          });
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
        });
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('应用详情'),
        actions: [
          if (widget.app.canUpdate)
            IconButton(
              icon: Icon(Icons.update),
              onPressed: _loading ? null : _updateApp,
            ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _loading ? null : _uninstallApp,
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
                      _buildBasicInfo(),
                      SizedBox(height: 24),
                      _buildStatusInfo(),
                      SizedBox(height: 24),
                      _buildResourceInfo(),
                      SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    base64Decode(widget.app.icon),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.app.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '版本: ${widget.app.version}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (widget.app.message.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                widget.app.message,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '状态信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('状态', widget.app.status),
            _buildInfoRow('类型', widget.app.appType),
            _buildInfoRow('创建时间', widget.app.createdAt.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '资源信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow('HTTP端口', widget.app.httpPort.toString()),
            _buildInfoRow('HTTPS端口', widget.app.httpsPort.toString()),
            _buildInfoRow('安装路径', widget.app.path),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _loading ? null : (widget.app.status == 'running' ? _stopApp : _startApp),
            icon: Icon(widget.app.status == 'running' ? Icons.stop : Icons.play_arrow),
            label: Text(widget.app.status == 'running' ? '停止' : '启动'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        if (widget.app.canUpdate) ...[
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _updateApp,
              icon: Icon(Icons.update),
              label: Text('更新'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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