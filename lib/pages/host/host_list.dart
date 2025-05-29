import 'package:flutter/material.dart';
import '../../common/api/host.dart';
import '../../common/model/host.dart';
import 'host_detail.dart';
import 'host_form.dart';

class HostListPage extends StatefulWidget {
  const HostListPage({super.key});

  @override
  State<HostListPage> createState() => _HostListPageState();
}

class _HostListPageState extends State<HostListPage> {
  List<Host> _hostList = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchHosts();
  }

  Future<void> _fetchHosts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiHost.getList();
      if (res.success && res.data != null) {
        setState(() {
          _hostList = res.data!;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取主机列表失败';
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

  Future<void> _deleteHost(Host host) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除主机 ${host.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final res = await ApiHost.delete(host.id);
        if (res.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('删除成功')),
          );
          _fetchHosts();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.message ?? '删除失败')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('主机管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchHosts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HostFormPage()),
          );
          if (result == true) {
            _fetchHosts();
          }
        },
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : RefreshIndicator(
                  onRefresh: _fetchHosts,
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _hostList.length,
                    itemBuilder: (context, index) {
                      final host = _hostList[index];
                      return Card(
                        child: InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HostDetailPage(host: host),
                              ),
                            );
                            if (result == true) {
                              _fetchHosts();
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        host.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _buildStatusChip(host.status),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '地址: ${host.address}:${host.port}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '类型: ${host.type}',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (host.description.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    host.description,
                                    style: TextStyle(color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () async {
                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                HostFormPage(host: host),
                                          ),
                                        );
                                        if (result == true) {
                                          _fetchHosts();
                                        }
                                      },
                                      icon: Icon(Icons.edit, size: 18),
                                      label: Text('编辑'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _deleteHost(host),
                                      icon: Icon(Icons.delete, size: 18),
                                      label: Text('删除'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'online':
        color = Colors.green;
        break;
      case 'offline':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
      ),
    );
  }
} 