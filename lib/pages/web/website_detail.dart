import 'package:flutter/material.dart';
import '../../common/model/website.dart';
import 'web_file_manager.dart';

class WebsiteDetailPage extends StatefulWidget {
  final WebsiteItem website;

  const WebsiteDetailPage({
    super.key,
    required this.website,
  });

  @override
  State<WebsiteDetailPage> createState() => _WebsiteDetailPageState();
}

class _WebsiteDetailPageState extends State<WebsiteDetailPage> {
  // TODO: 根据 websiteId 调用API获取网站详情
  // 这里只是静态UI示例
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('网站详情'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: 编辑网站
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // TODO: 删除网站
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: 刷新网站状态
            },
          ),
          IconButton(
            icon: Icon(Icons.folder),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebFileManager(website: widget.website),
                ),
              );
            },
            tooltip: '文件管理',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('网站名称: example.com', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('域名: www.example.com'),
            SizedBox(height: 8),
            Text('状态: 已启用'),
            SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // TODO: 启动/停止网站
                  },
                  child: Text('启用/停用'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 备份
                  },
                  child: Text('备份'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 查看日志
                  },
                  child: Text('日志'),
                ),
              ],
            ),
            // 你可以继续补充更多网站相关信息和操作
          ],
        ),
      ),
    );
  }
} 