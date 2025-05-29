import 'package:flutter/material.dart';
import '../../common/api/app.dart';
import '../../common/model/app.dart';

class WebAppSelector extends StatefulWidget {
  const WebAppSelector({super.key});

  @override
  State<WebAppSelector> createState() => _WebAppSelectorState();
}

class _WebAppSelectorState extends State<WebAppSelector> {
  List<AppsItem> _appList = [];
  bool _loading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchApps();
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
        "tags": [],
        "type": "",
        "orderBy": "downloads",
        "order": "desc",
      });
      if (res.success) {
        setState(() {
          _appList = res.data ?? [];
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

  List<AppsItem> get _filteredApps {
    if (_searchQuery.isEmpty) {
      return _appList;
    }
    return _appList.where((app) {
      return app.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          app.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择应用'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchApps,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: '搜索应用',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
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
                    : _filteredApps.isEmpty
                        ? Center(
                            child: Text(
                              '没有找到应用',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: _filteredApps.length,
                            itemBuilder: (context, index) {
                              final app = _filteredApps[index];
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context, app);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (app.icon.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.only(right: 16),
                                                child: Hero(
                                                  tag: 'web_create_app_icon_${app.id}',
                                                  child: Image.network(
                                                    app.icon,
                                                    width: 40,
                                                    height: 40,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Icon(Icons.apps, size: 40);
                                                    },
                                                  ),
                                                ),
                                              ),
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
                                                  if (app.description.isNotEmpty) ...[
                                                    SizedBox(height: 4),
                                                    Text(
                                                      app.description,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                            Icon(Icons.chevron_right),
                                          ],
                                        ),
                                        if (app.tags != null && app.tags is List) ...[
                                          SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            children: (app.tags as List).map((tag) {
                                              return Chip(
                                                label: Text(
                                                  tag.toString(),
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                                backgroundColor: Colors.grey[200],
                                                padding: EdgeInsets.zero,
                                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
} 