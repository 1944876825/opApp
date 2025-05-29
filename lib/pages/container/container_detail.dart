import 'package:flutter/material.dart';
import 'package:op_app/common/api/container.dart';
import 'package:op_app/common/model/container.dart';

class ContainerDetailPage extends StatefulWidget {
  final String containerId; // 传入容器ID

  const ContainerDetailPage({super.key, required this.containerId});

  @override
  State<ContainerDetailPage> createState() => _ContainerDetailPageState();
}

class _ContainerDetailPageState extends State<ContainerDetailPage> {
  ContainerItem? _container;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // 这里只能用search接口查找所有容器再筛选，后续可优化为单独详情API
      var res = await ApiContainer.search();
      if (res.success && res.data != null) {
        ContainerItem? found;
        for (var e in res.data!) {
          if (e.containerId == widget.containerId) {
            found = e;
            break;
          }
        }
        setState(() {
          _container = found;
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
        title: Text('容器详情'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: 编辑容器
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // TODO: 删除容器
            },
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _container == null
                  ? Center(child: Text('未找到容器'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('容器名称: ${_container!.name}', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                          Text('镜像: ${_container!.imageName}'),
                          SizedBox(height: 8),
                          Text('状态: ${_container!.state}'),
                          SizedBox(height: 8),
                          Text('运行时长: ${_container!.runTime}'),
                          SizedBox(height: 8),
                          Text('端口: ${_container!.ports.join(", ")}'),
                          SizedBox(height: 8),
                          Text('网络: ${_container!.network.join(", ")}'),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: 启动/停止容器
                                },
                                child: Text('启动/停止'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: 查看日志
                                },
                                child: Text('日志'),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: 进入终端
                                },
                                child: Text('终端'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
    );
  }
} 