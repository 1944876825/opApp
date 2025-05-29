import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:op_app/common/api/app.dart';
import 'package:op_app/common/model/app.dart';
import 'app_detail.dart';
import 'apps.dart';
import 'package:flutter/services.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  List<AppItem> _appList = [];
  List<Tag> _tags = [];
  bool _loading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedTag = 'all';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchTags();
    _fetchApps();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchTags() async {
    try {
      final res = await ApiApp.appsTags();
      if (res.success && res.data != null) {
        setState(() {
          _tags = res.data!;
        });
      }
    } catch (e) {
      print('获取标签失败: $e');
    }
  }

  Future<void> _fetchApps() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiApp.installedSearch({
        "all": true,
        "name": _searchQuery,
        "page": 1,
        "pageSize": 20,
        "sync": true,
        "tags": _selectedTag == 'all' ? [] : [_selectedTag],
        "type": "",
        "unused": true,
        "update": true
      });

      if (res.success && res.data != null) {
        setState(() {
          _appList = res.data!;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取应用列表失败';
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

  void _showAppMenu(AppItem app) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.info),
            title: Text('查看详情'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppDetailPage(app: app),
                ),
              ).then((value) {
                if (value == true) {
                  _fetchApps();
                }
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('查看日志'),
            onTap: () {
              Navigator.pop(context);
              _showAppLog(app);
            },
          ),
          if (app.canUpdate)
            ListTile(
              leading: Icon(Icons.update),
              title: Text('更新'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppDetailPage(app: app),
                  ),
                ).then((value) {
                  if (value == true) {
                    _fetchApps();
                  }
                });
              },
            ),
          ListTile(
            leading: Icon(app.status == 'running' ? Icons.stop : Icons.play_arrow),
            title: Text(app.status == 'running' ? '停止' : '启动'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppDetailPage(app: app),
                ),
              ).then((value) {
                if (value == true) {
                  _fetchApps();
                }
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('卸载', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              _showUninstallDialog(app);
            },
          ),
        ],
      ),
    );
  }

  void _showUninstallDialog(AppItem app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认卸载'),
        content: Text('确定要卸载 ${app.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AppDetailPage(app: app),
                ),
              ).then((value) {
                if (value == true) {
                  _fetchApps();
                }
              });
            },
            child: Text('卸载', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("我的应用"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: AppSearchDelegate(
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                    _fetchApps();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchApps,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toAddApps,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (_tags.isNotEmpty)
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: _tags.length,
                itemBuilder: (context, index) {
                  final tag = _tags[index];
                  final isSelected = tag.key == _selectedTag;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTag = tag.key;
                        });
                        _fetchApps();
                      },
                    ),
                  );
                },
              ),
            ),
          Expanded(
            child: _loading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _fetchApps,
                              child: Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : _appList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.apps, size: 64, color: Colors.grey),
                                SizedBox(height: 16),
                                Text(
                                  '暂无应用',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: _toAddApps,
                                  icon: Icon(Icons.add),
                                  label: Text('添加应用'),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _fetchApps,
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(16),
                              itemCount: _appList.length,
                              itemBuilder: (context, index) {
                                final app = _appList[index];
                                return Card(
                                  child: InkWell(
                                    onTap: () => _showAppMenu(app),
                                    borderRadius: BorderRadius.circular(12),
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
                                                  base64Decode(app.icon),
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      app.name,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      app.version,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _buildStatusChip(app.status),
                                            ],
                                          ),
                                          if (app.message.isNotEmpty) ...[
                                            SizedBox(height: 8),
                                            Text(
                                              app.message,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              if (app.canUpdate)
                                                TextButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => AppDetailPage(app: app),
                                                      ),
                                                    ).then((value) {
                                                      if (value == true) {
                                                        _fetchApps();
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(Icons.update, size: 16),
                                                  label: Text('更新'),
                                                ),
                                              TextButton.icon(
                                                onPressed: () => _showAppMenu(app),
                                                icon: Icon(Icons.more_vert, size: 16),
                                                label: Text('更多'),
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
          ),
        ],
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
      case 'installing':
        color = Colors.orange;
        icon = Icons.download;
        label = '安装中';
        break;
      case 'updating':
        color = Colors.blue;
        icon = Icons.update;
        label = '更新中';
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

  void _toAddApps() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => AppsPage()));
  }

  void _showAppLog(AppItem app) {
    final composePath = '/opt/1panel/apps/${app.appKey}/${app.name}/docker-compose.yml';
    final logStream = ApiApp.getRealtimeLog(composePath);
    final logController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('应用日志'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: StreamBuilder<String>(
            stream: logStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('获取日志失败: ${snapshot.error}');
              }
              
              if (snapshot.hasData) {
                try {
                  final data = snapshot.data!;
                  if (data is String) {
                    logController.text = data;
                  } else {
                    logController.text = data.toString();
                  }
                } catch (e) {
                  print('处理日志数据失败: $e');
                  return Text('处理日志数据失败: $e');
                }
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8),
                child: TextField(
                  controller: logController,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  maxLines: null,
                  readOnly: true,
                  decoration: null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }
}

class AppSearchDelegate extends SearchDelegate {
  final Function(String) onSearch;

  AppSearchDelegate({required this.onSearch});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
