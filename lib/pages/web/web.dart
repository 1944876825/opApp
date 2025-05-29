import 'package:flutter/material.dart';
import 'dart:convert';

import '../../common/api/websites.dart';
import '../../common/model/websites.dart';
import '../../common/model/website.dart';
import 'web_create.dart';
import 'website_detail.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  List<WebSiteItem> _webList = [];
  bool _loading = true;
  String? _error;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchWebsites();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchWebsites() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiWebsites.getList();
      if (res.success && res.data != null) {
        setState(() {
          _webList = res.data!;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取网站列表失败';
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

  void _showWebMenu(WebSiteItem web) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('查看详情'),
            onTap: () {
              Navigator.pop(context);
              _showWebDetail(web);
            },
          ),
          ListTile(
            leading: Icon(Icons.article_outlined),
            title: Text('查看日志'),
            onTap: () {
              Navigator.pop(context);
              _showWebLog(web);
            },
          ),
          ListTile(
            leading: Icon(web.status == 'running' ? Icons.stop : Icons.play_arrow),
            title: Text(web.status == 'running' ? '停止' : '启动'),
            onTap: () {
              Navigator.pop(context);
              _toggleWebStatus(web);
            },
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text('重启'),
            onTap: () {
              Navigator.pop(context);
              _restartWeb(web);
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red),
            title: Text('删除', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirm(web);
            },
          ),
        ],
      ),
    );
  }

  void _showWebDetail(WebSiteItem web) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebsiteDetailPage(
          website: WebsiteItem(
            id: web.id,
            name: web.primaryDomain,
            domain: web.primaryDomain,
            port: web.domains.first.port,
            type: web.type,
            rootPath: web.sitePath,
            enableSSL: web.webSiteSslId > 0,
            enableBackup: false,
            enableMonitor: false,
            enableIPv6: web.ipv6,
            enableFTP: web.ftpId > 0,
            enableGzip: true,
            enableCache: true,
            enableLog: web.errorLog || web.accessLog,
            remark: web.remark,
            runtimeId: web.runtimeId.toString(),
            runtimeTypeName: web.runtimeName,
            runtimeVersion: null,
            appId: web.appInstallId.toString(),
            appKey: null,
            proxyTarget: web.proxy,
            status: web.status,
            createdAt: web.createdAt,
            updatedAt: web.updatedAt,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
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

  void _showDeleteConfirm(WebSiteItem web) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除网站 ${web.primaryDomain} 吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteWeb(web);
            },
            child: Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleWebStatus(WebSiteItem web) async {
    try {
      final res = await ApiWebsites.toggleStatus(web.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('操作成功')),
        );
        _fetchWebsites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? '操作失败')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败: $e')),
      );
    }
  }

  Future<void> _restartWeb(WebSiteItem web) async {
    try {
      final res = await ApiWebsites.restart(web.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('重启成功')),
        );
        _fetchWebsites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? '重启失败')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('重启失败: $e')),
      );
    }
  }

  Future<void> _deleteWeb(WebSiteItem web) async {
    try {
      final res = await ApiWebsites.delete(web.id.toString());
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('删除成功')),
        );
        _fetchWebsites();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message ?? '删除失败')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('删除失败: $e')),
      );
    }
  }

  void _showWebLog(WebSiteItem web) async {
    try {
      final log = await ApiWebsites.getLog(web.id.toString());
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${web.primaryDomain} 日志',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        log.data ?? '暂无日志',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取日志失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("网站"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchWebsites,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebCreatePage()),
          );
          if (result == true) {
            _fetchWebsites();
          }
        },
        child: Icon(Icons.add),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchWebsites,
                        child: Text('重试'),
                      ),
                    ],
                  ),
                )
              : _webList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.web, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            '暂无网站',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => WebCreatePage()),
                              );
                              if (result == true) {
                                _fetchWebsites();
                              }
                            },
                            icon: Icon(Icons.add),
                            label: Text('添加网站'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchWebsites,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.all(16),
              itemCount: _webList.length,
              itemBuilder: (context, index) {
                          final web = _webList[index];
                return Card(
                    child: InkWell(
                              onTap: () => _showWebMenu(web),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    web.appName,
                                    style: TextStyle(
                                                  fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (web.alias.isNotEmpty) ...[
                                                SizedBox(height: 4),
                                                Text(
                                                  web.alias,
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        _buildStatusChip(web.status),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.memory, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          'CPU: 0.09%',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(Icons.storage, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          '内存: 128MB',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
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
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'running':
        color = Colors.green;
        icon = Icons.play_circle;
        label = '运行中';
        break;
      case 'stopped':
        color = Colors.red;
        icon = Icons.stop_circle;
        label = '已停止';
        break;
      case 'starting':
        color = Colors.orange;
        icon = Icons.download;
        label = '启动中';
        break;
      case 'stopping':
        color = Colors.orange;
        icon = Icons.stop;
        label = '停止中';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        label = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
