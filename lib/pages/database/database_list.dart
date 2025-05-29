import 'package:flutter/material.dart';
import 'package:op_app/common/api/database.dart';
import 'package:op_app/common/model/database.dart';

class DatabaseListPage extends StatefulWidget {
  const DatabaseListPage({super.key});

  @override
  State<DatabaseListPage> createState() => _DatabaseListPageState();
}

class _DatabaseListPageState extends State<DatabaseListPage> {
  List<DatabaseItem> _databaseList = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDatabases();
  }

  Future<void> _fetchDatabases() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      var res = await ApiDatabase.search();
      if (res.success && res.data != null) {
        setState(() {
          _databaseList = res.data!;
          _loading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取失败';
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
        title: Text('数据库管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: 添加数据库
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchDatabases,
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _databaseList.isEmpty
                  ? Center(child: Text('暂无数据库'))
                  : ListView.builder(
                      itemCount: _databaseList.length,
                      itemBuilder: (context, index) {
                        final db = _databaseList[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ListTile(
                            title: Text(db.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('类型: ${db.type} ${db.version}'),
                                Text('状态: ${db.status}'),
                                Text('端口: ${db.port}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.play_arrow),
                                  onPressed: () async {
                                    // 根据状态显示不同操作
                                    if (db.status == 'stopped') {
                                      await ApiDatabase.start(db.id);
                                    } else {
                                      await ApiDatabase.stop(db.id);
                                    }
                                    _fetchDatabases();
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // TODO: 编辑数据库
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    // 确认删除
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('确认删除'),
                                        content: Text('确定要删除数据库 ${db.name} 吗？'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: Text('取消'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: Text('确定'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await ApiDatabase.delete(db.id);
                                      _fetchDatabases();
                                    }
                                  },
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
    );
  }
} 