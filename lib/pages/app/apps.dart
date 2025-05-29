import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:op_app/pages/app/install.dart';
import 'package:flutter/services.dart';

import '../../common/api/app.dart';
import '../../common/model/app.dart';

class AppsPage extends StatefulWidget {
  const AppsPage({super.key});

  @override
  State<AppsPage> createState() => _AppsPageState();
}

class _AppsPageState extends State<AppsPage> {
  List<AppsItem> _appList = [];
  List<Tag> _tags = [];
  bool _loading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedTag = 'all';
  String _sortBy = 'name';
  String _sortOrder = 'asc';
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
      final res = await ApiApp.appsSearch({
        "all": true,
        "name": _searchQuery,
        "page": 1,
        "pageSize": 20,
        "sync": true,
        "tags": _selectedTag == 'all' ? [] : [_selectedTag],
        "type": "",
        "orderBy": _sortBy,
        "order": _sortOrder,
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

  Future<void> _uninstallApp(AppsItem app) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认卸载'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要卸载 ${app.name} 吗？'),
            SizedBox(height: 8),
            Text(
              '卸载后将删除所有数据，此操作不可恢复。',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ],
        ),
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
      try {
        setState(() {
          _loading = true;
          _error = null;
        });

        final res = await ApiApp.uninstall(app.id.toString());
        if (res.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('卸载成功'),
              action: SnackBarAction(
                label: '查看日志',
                onPressed: () => _showUninstallLog(app.name),
              ),
            ),
          );
          // 刷新应用列表
          _fetchApps();
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

  Future<void> _showUninstallLog(String name) async {
    try {
      final res = await ApiApp.installLog(name);
      if (res.success && res.data != null) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('卸载日志'),
            content: Container(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: SelectableText(
                  res.data!,
                  style: TextStyle(fontFamily: 'monospace'),
                ),
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
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取日志失败: $e')),
      );
    }
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('排序方式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('名称'),
              value: 'name',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  _sortOrder = 'asc';
                });
                Navigator.pop(context);
                _fetchApps();
              },
            ),
            RadioListTile<String>(
              title: Text('下载量'),
              value: 'downloads',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
                _fetchApps();
              },
            ),
            RadioListTile<String>(
              title: Text('更新时间'),
              value: 'updated_at',
              groupValue: _sortBy,
              onChanged: (value) {
                setState(() {
                  _sortBy = value!;
                  _sortOrder = 'desc';
                });
                Navigator.pop(context);
                _fetchApps();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
        ],
      ),
    );
  }

  void _showAppDetail(AppsItem app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          app.type,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.all(16),
                children: [
                  if (app.description.isNotEmpty) ...[
                    Text(
                      '应用描述',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(app.description),
                    SizedBox(height: 16),
                  ],
                  if (app.resource.isNotEmpty) ...[
                    Text(
                      '资源要求',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(app.resource),
                    SizedBox(height: 16),
                  ],
                  if (app.versions != null && app.versions.isNotEmpty) ...[
                    Text(
                      '可用版本',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var version in app.versions)
                          Chip(label: Text(version.toString())),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                  if (app.tags != null && app.tags.isNotEmpty) ...[
                    Text(
                      '标签',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (var tag in app.tags)
                          Chip(
                            label: Text(tag.toString()),
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            labelStyle: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            child: Row(
                children: [
                  if (app.installed) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showAppLog(app),
                        icon: Icon(Icons.article),
                        label: Text('查看日志'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstallPage(
                              appName: app.name,
                              appKey: app.key),
                          ),
                        );
                      },
                      icon: Icon(Icons.download),
                      label: Text('安装'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppLog(AppsItem app) {
    final composePath = '/opt/1panel/apps/${app.key}/${app.name}/docker-compose.yml';
    print("mydebug composePath $composePath");
    final logStream = ApiApp.getRealtimeLog(composePath);
    final logController = TextEditingController();
    final searchController = TextEditingController();
    String searchText = '';
    String logLevel = 'all';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Row(
            children: [
              Text('应用日志'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  // 重新连接 WebSocket
                  final newLogStream = ApiApp.getRealtimeLog(composePath);
                  setState(() {});
                },
                tooltip: '刷新',
              ),
              IconButton(
                icon: Icon(Icons.clear_all),
                onPressed: () {
                  logController.clear();
                },
                tooltip: '清空',
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 500,
            child: Column(
              children: [
                // 搜索和过滤工具栏
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: '搜索日志...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 8),
                      DropdownButton<String>(
                        value: logLevel,
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('全部')),
                          DropdownMenuItem(value: 'info', child: Text('信息')),
                          DropdownMenuItem(value: 'warning', child: Text('警告')),
                          DropdownMenuItem(value: 'error', child: Text('错误')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                        setState(() {
                              logLevel = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // 日志内容
                Expanded(
                  child: StreamBuilder<String>(
                    stream: logStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red, size: 48),
                              SizedBox(height: 16),
                              Text('获取日志失败: ${snapshot.error}'),
                            ],
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        final log = snapshot.data!;
                        logController.text = log;
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
              ],
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                // 复制所有日志
                final text = logController.text;
                if (text.isNotEmpty) {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('日志已复制到剪贴板')),
                  );
                }
              },
              icon: Icon(Icons.copy),
              label: Text('复制全部'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('关闭'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("应用商店"),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
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
                                    onTap: () => _showAppDetail(app),
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
                                                      app.type,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              _buildStatusChip(app.installed),
                                            ],
                                          ),
                                          if (app.description.isNotEmpty) ...[
                                            SizedBox(height: 8),
                                            Text(
                            app.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                                              TextButton.icon(
                                                onPressed: () => _showAppDetail(app),
                                                icon: Icon(Icons.info_outline, size: 16),
                                                label: Text('详情'),
                                              ),
                                              SizedBox(width: 8),
                                              ElevatedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => InstallPage(
                                                        appName: app.name,
                                                        appKey: app.key,),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(Icons.download, size: 16),
                                                label: Text('安装'),
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

  Widget _buildStatusChip(bool installed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: installed ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            installed ? Icons.check_circle : Icons.download,
            size: 16,
            color: installed ? Colors.green : Colors.grey,
          ),
          SizedBox(width: 4),
          Text(
            installed ? '已安装' : '未安装',
        style: TextStyle(
              color: installed ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
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
