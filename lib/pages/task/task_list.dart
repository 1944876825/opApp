import 'package:flutter/material.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: 调用API获取任务计划列表
    // 这里只是静态UI示例
    return Scaffold(
      appBar: AppBar(
        title: Text('任务计划'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // TODO: 添加任务
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 5, // 示例数据
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('任务 ${index + 1}'),
              subtitle: Text('描述: 这是一个示例任务'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // TODO: 编辑任务
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // TODO: 删除任务
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 