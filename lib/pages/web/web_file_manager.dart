import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../common/api/websites.dart';
import '../../common/model/website.dart';
import '../../common/model/file_item.dart';

class WebFileManager extends StatefulWidget {
  final WebsiteItem website;

  const WebFileManager({
    super.key,
    required this.website,
  });

  @override
  State<WebFileManager> createState() => _WebFileManagerState();
}

class _WebFileManagerState extends State<WebFileManager> {
  String _currentPath = '/';
  List<FileItem> _fileList = [];
  bool _isLoading = false;
  String? _error;
  bool _isUploading = false;
  double _uploadProgress = 0;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final res = await ApiWebsites.listFiles(
        widget.website.id.toString(),
        _currentPath,
      );
      if (res.success && res.data != null) {
        setState(() {
          _fileList = res.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = res.message ?? '获取文件列表失败';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (result != null) {
        setState(() {
          _isUploading = true;
          _uploadProgress = 0;
        });

        // TODO: 实现文件上传
        // 这里需要调用文件上传 API

        setState(() {
          _isUploading = false;
        });
        _loadFiles();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isUploading = false;
      });
    }
  }

  Future<void> _createFolder() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('新建文件夹'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '文件夹名称',
            hintText: '请输入文件夹名称',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('确定'),
          ),
        ],
      ),
    );

    if (name != null && name.isNotEmpty) {
      try {
        final res = await ApiWebsites.createFolder(
          widget.website.id.toString(),
          '$_currentPath$name',
        );
        if (res.success) {
          _loadFiles();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.message ?? '创建文件夹失败')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建文件夹失败: $e')),
        );
      }
    }
  }

  Future<void> _deleteFile(FileItem file) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认删除'),
        content: Text('确定要删除 ${file.isDirectory ? '文件夹' : '文件'} "${file.name}" 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final res = await ApiWebsites.deleteFile(
          widget.website.id.toString(),
          file.path,
        );
        if (res.success) {
          _loadFiles();
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
  }

  Future<void> _renameFile(FileItem file) async {
    final controller = TextEditingController(text: file.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('重命名'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '新名称',
            hintText: '请输入新名称',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('确定'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != file.name) {
      try {
        final res = await ApiWebsites.renameFile(
          widget.website.id.toString(),
          file.path,
          newName,
        );
        if (res.success) {
          _loadFiles();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res.message ?? '重命名失败')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('重命名失败: $e')),
        );
      }
    }
  }

  Widget _buildFileItem(FileItem file) {
    return ListTile(
      leading: Icon(
        file.isDirectory ? Icons.folder : Icons.insert_drive_file,
        color: file.isDirectory ? Colors.amber : Colors.blue,
      ),
      title: Text(file.name),
      subtitle: Text(
        file.isDirectory
            ? '${file.items ?? 0} 个项目'
            : '${(file.size ?? 0) ~/ 1024} KB',
      ),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          if (!file.isDirectory)
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('下载'),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.pop(context);
                  // TODO: 实现文件下载
                },
              ),
            ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.edit),
              title: Text('重命名'),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(context);
                _renameFile(file);
              },
            ),
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('删除', style: TextStyle(color: Colors.red)),
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.pop(context);
                _deleteFile(file);
              },
            ),
          ),
        ],
      ),
      onTap: () {
        if (file.isDirectory) {
          setState(() {
            _currentPath = file.path;
            print("mydebug _currentPath $_currentPath");
          });
          _loadFiles();
        } else {
          // TODO: 实现文件预览
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文件管理'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFiles,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _currentPath,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.upload_file),
                  onPressed: _isUploading ? null : _uploadFiles,
                  tooltip: '上传文件',
                ),
                IconButton(
                  icon: Icon(Icons.create_new_folder),
                  onPressed: _createFolder,
                  tooltip: '新建文件夹',
                ),
              ],
            ),
          ),
          if (_isUploading)
            LinearProgressIndicator(
              value: _uploadProgress,
            ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadFiles,
                              child: Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : _fileList.isEmpty
                        ? Center(
                            child: Text(
                              '当前目录为空',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _fileList.length,
                            itemBuilder: (context, index) {
                              return _buildFileItem(_fileList[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }
} 