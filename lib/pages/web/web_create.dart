import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/api/websites.dart';
import '../../common/api/runtime.dart';
import '../../common/model/app.dart';
import '../../common/model/runtime.dart';
import 'web_app_selector.dart';

class WebCreatePage extends StatefulWidget {
  const WebCreatePage({super.key});

  @override
  State<WebCreatePage> createState() => _WebCreatePageState();
}

class _WebCreatePageState extends State<WebCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _domainController = TextEditingController();
  final _portController = TextEditingController(text: '80');
  final _remarkController = TextEditingController();
  final _rootPathController = TextEditingController(text: '/www/wwwroot');
  String _selectedType = 'static';
  String? _selectedRuntime;
  String? _selectedRuntimeVersion;
  AppsItem? _selectedApp;
  String? _selectedProxyTarget;
  bool _isLoading = false;
  bool _isCheckingPort = false;
  bool _isPortAvailable = true;
  bool _enableSSL = false;
  bool _enableBackup = false;
  bool _enableMonitor = false;
  bool _enableIPv6 = false;
  bool _enableFTP = false;
  bool _enableGzip = true;
  bool _enableCache = true;
  bool _enableLog = true;

  List<RuntimeItem> _runtimeList = [];
  bool _loadingRuntimes = false;
  String? _runtimeError;

  // 运行环境类型常量
  static const List<Map<String, String>> _runtimeTypeOptions = [
    {'value': 'php', 'label': 'PHP'},
    {'value': 'node', 'label': 'Node.js'},
    {'value': 'java', 'label': 'Java'},
    {'value': 'go', 'label': 'Go'},
    {'value': 'python', 'label': 'Python'},
    {'value': 'dotnet', 'label': '.NET'},
  ];

  // 网站类型说明
  final Map<String, String> _typeDescriptions = {
    'static': '用于托管静态文件，如HTML、CSS、JavaScript等',
    'runtime': '用于运行特定编程语言的应用程序',
    'app': '一键部署预配置的应用程序',
    'proxy': '将请求转发到其他服务器',
  };

  @override
  void initState() {
    super.initState();
    _portController.addListener(_checkPort);
    _fetchRuntimes();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _portController.dispose();
    _remarkController.dispose();
    _rootPathController.dispose();
    super.dispose();
  }

  Future<void> _checkPort() async {
    if (_portController.text.isEmpty) return;
    
    final port = int.tryParse(_portController.text);
    if (port == null || port <= 0 || port > 65535) return;

    setState(() {
      _isCheckingPort = true;
    });

    try {
      final res = await ApiWebsites.checkPort(port);
      setState(() {
        _isPortAvailable = res.success;
        _isCheckingPort = false;
      });
    } catch (e) {
      setState(() {
        _isPortAvailable = false;
        _isCheckingPort = false;
      });
    }
  }

  Future<void> _fetchRuntimes() async {
    setState(() {
      _loadingRuntimes = true;
      _runtimeError = null;
    });

    try {
      final res = await ApiRuntime.search(
        status: _selectedRuntime == 'php' ? 'normal' : 'running',
        type: _selectedRuntime,
      );
      if (res.success) {
        setState(() {
          _runtimeList = res.data ?? [];
          _loadingRuntimes = false;
        });
      } else {
        setState(() {
          _runtimeError = res.message ?? '获取运行环境列表失败';
          _loadingRuntimes = false;
        });
      }
    } catch (e) {
      setState(() {
        _runtimeError = e.toString();
        _loadingRuntimes = false;
      });
    }
  }

  bool _isValidDomain(String domain) {
    // 简单的域名验证
    final domainRegex = RegExp(
      r'^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'
    );
    return domainRegex.hasMatch(domain);
  }

  Future<void> _createWebsite() async {
    if (!_formKey.currentState!.validate()) return;

    // 显示确认对话框
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('确认创建'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请确认以下信息：'),
            SizedBox(height: 16),
            _buildConfirmItem('域名', _domainController.text),
            _buildConfirmItem('端口', _portController.text),
            _buildConfirmItem('类型', _getTypeName(_selectedType)),
            _buildConfirmItem('根目录', _rootPathController.text),
            if (_selectedType == 'runtime' && _selectedRuntime != null) ...[
              _buildConfirmItem('运行环境', _getTypeName(_selectedRuntime!)),
              if (_selectedRuntimeVersion != null)
                _buildConfirmItem('版本', _selectedRuntimeVersion!),
            ],
            if (_selectedType == 'app' && _selectedApp != null)
              _buildConfirmItem('应用', _selectedApp!.name),
            if (_selectedType == 'proxy' && _selectedProxyTarget != null)
              _buildConfirmItem('代理目标', _selectedProxyTarget!),
            if (_enableSSL)
              _buildConfirmItem('SSL', '已启用'),
            if (_enableBackup)
              _buildConfirmItem('备份', '已启用'),
            if (_enableMonitor)
              _buildConfirmItem('监控', '已启用'),
            if (_enableIPv6)
              _buildConfirmItem('IPv6', '已启用'),
            if (_enableFTP)
              _buildConfirmItem('FTP', '已启用'),
            if (_enableGzip)
              _buildConfirmItem('Gzip', '已启用'),
            if (_enableCache)
              _buildConfirmItem('缓存', '已启用'),
            if (_enableLog)
              _buildConfirmItem('日志', '已启用'),
            if (_remarkController.text.isNotEmpty)
              _buildConfirmItem('备注', _remarkController.text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('确认创建'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final Map<String, dynamic> data = {
        'domain': _domainController.text,
        'port': int.parse(_portController.text),
        'type': _selectedType,
        'remark': _remarkController.text,
        'rootPath': _rootPathController.text,
        'enableSSL': _enableSSL,
        'enableBackup': _enableBackup,
        'enableMonitor': _enableMonitor,
        'enableIPv6': _enableIPv6,
        'enableFTP': _enableFTP,
        'enableGzip': _enableGzip,
        'enableCache': _enableCache,
        'enableLog': _enableLog,
      };

      // 根据类型添加额外参数
      switch (_selectedType) {
        case 'runtime':
          if (_selectedRuntime == null) {
            throw Exception('请选择运行环境类型');
          }
          final runtime = _runtimeList.firstWhere(
            (r) => r.version == _selectedRuntimeVersion,
            orElse: () => throw Exception('请选择运行环境版本'),
          );
          data['runtimeId'] = runtime.id.toString();
          data['runtimeType'] = runtime.type;
          data['runtimeVersion'] = runtime.version;
          break;
        case 'app':
          if (_selectedApp == null) {
            throw Exception('请选择应用');
          }
          data['appId'] = _selectedApp!.id.toString();
          data['appKey'] = _selectedApp!.key;
          break;
        case 'proxy':
          if (_selectedProxyTarget == null) {
            throw Exception('请输入代理目标');
          }
          data['proxyTarget'] = _selectedProxyTarget;
          break;
      }

      final res = await ApiWebsites.create(data);

      if (res.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('创建成功')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception(res.message ?? '创建失败');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('创建失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildConfirmItem(String label, String value) {
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

  String _getTypeName(String type) {
    switch (type) {
      case 'static':
        return '静态网站';
      case 'runtime':
        return '运行环境';
      case 'app':
        return '一键部署';
      case 'proxy':
        return '反向代理';
      default:
        return type;
    }
  }

  Widget _buildTypeSpecificFields() {
    switch (_selectedType) {
      case 'runtime':
        return Column(
          children: [
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRuntime,
              decoration: InputDecoration(
                labelText: '运行环境类型',
                prefixIcon: Icon(Icons.code),
              ),
              items: _runtimeTypeOptions.map((item) => DropdownMenuItem(
                value: item['value'],
                child: Text(item['label']!),
              )).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRuntime = value;
                    _selectedRuntimeVersion = null;
                  });
                  _fetchRuntimes();
                }
              },
              validator: (value) {
                if (value == null) {
                  return '请选择运行环境类型';
                }
                return null;
              },
            ),
            if (_selectedRuntime != null) ...[
              SizedBox(height: 16),
              if (_loadingRuntimes)
                Center(child: CircularProgressIndicator())
              else if (_runtimeError != null)
                Center(
                  child: Column(
                    children: [
                      Text(_runtimeError!),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _fetchRuntimes,
                        child: Text('重试'),
                      ),
                    ],
                  ),
                )
              else if (_runtimeList.isEmpty)
                Center(
                  child: Text(
                    '没有可用的运行环境',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              else
                DropdownButtonFormField<RuntimeItem>(
                  value: _runtimeList.where((r) => r.version == _selectedRuntimeVersion).isNotEmpty
                      ? _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion)
                      : null,
                  decoration: InputDecoration(
                    labelText: '运行环境版本',
                    prefixIcon: Icon(Icons.tag),
                  ),
                  isExpanded: true,
                  items: _runtimeList.map((runtime) {
                    return DropdownMenuItem(
                      value: runtime,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 100),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                runtime.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: runtime.statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                runtime.statusDisplay,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: runtime.statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedRuntimeVersion = value.version;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null) {
                      return '请选择运行环境版本';
                    }
                    return null;
                  },
                ),
                if (_selectedRuntimeVersion != null) ...[
                  SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '运行环境详情',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildRuntimeDetailItem('名称', _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).name),
                          _buildRuntimeDetailItem('版本', _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).version),
                          _buildRuntimeDetailItem('状态', _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).statusDisplay),
                          _buildRuntimeDetailItem('路径', _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).path),
                          if (_runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).port > 0)
                            _buildRuntimeDetailItem('端口', _runtimeList.firstWhere((r) => r.version == _selectedRuntimeVersion).port.toString()),
                        ],
                      ),
                    ),
                  ),
                ],
            ],
          ],
        );
      case 'app':
        return Column(
          children: [
            SizedBox(height: 16),
            if (_selectedApp != null)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (_selectedApp?.icon.isNotEmpty ?? false)
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Hero(
                                tag: 'web_create_app_icon_${_selectedApp?.id}',
                                child: Image.network(
                                  _selectedApp!.icon,
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
                                  _selectedApp!.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_selectedApp!.description.isNotEmpty) ...[
                                  SizedBox(height: 4),
                                  Text(
                                    _selectedApp!.description,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _selectedApp = null;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () async {
                  final app = await Navigator.push<AppsItem>(
                    context,
                    MaterialPageRoute(builder: (context) => WebAppSelector()),
                  );
                  if (app != null) {
                    setState(() {
                      _selectedApp = app;
                    });
                  }
                },
                icon: Icon(Icons.add),
                label: Text('选择应用'),
              ),
          ],
        );
      case 'proxy':
        return Column(
          children: [
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: '代理目标',
                hintText: '请输入代理目标地址',
                prefixIcon: Icon(Icons.link),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedProxyTarget = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入代理目标地址';
                }
                return null;
              },
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  // 构建运行环境详情项
  Widget _buildRuntimeDetailItem(String label, String value) {
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
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 选择网站根目录
  Future<void> _selectRootPath() async {
    // TODO: 实现目录选择器
    // 这里需要调用系统文件选择器或自定义目录选择器
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建网站'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _domainController,
              decoration: InputDecoration(
                labelText: '域名',
                hintText: '请输入域名',
                prefixIcon: Icon(Icons.domain),
                helperText: '例如：example.com',
                suffixIcon: IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('域名说明'),
                        content: Text('请输入完整的域名，例如：example.com\n支持多个域名，用逗号分隔'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('确定'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入域名';
                }
                if (!_isValidDomain(value)) {
                  return '请输入有效的域名';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _portController,
              decoration: InputDecoration(
                labelText: '端口',
                hintText: '请输入端口号',
                prefixIcon: Icon(Icons.numbers),
                helperText: _isCheckingPort
                    ? '检查端口可用性...'
                    : _isPortAvailable
                        ? '端口可用'
                        : '端口已被占用',
                helperStyle: TextStyle(
                  color: _isCheckingPort
                      ? Colors.grey
                      : _isPortAvailable
                          ? Colors.green
                          : Colors.red,
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入端口号';
                }
                final port = int.tryParse(value);
                if (port == null || port <= 0 || port > 65535) {
                  return '请输入有效的端口号(1-65535)';
                }
                if (!_isPortAvailable) {
                  return '端口已被占用';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _rootPathController,
              decoration: InputDecoration(
                labelText: '网站根目录',
                hintText: '请输入网站根目录',
                prefixIcon: Icon(Icons.folder),
                helperText: '网站文件存放的目录',
                suffixIcon: IconButton(
                  icon: Icon(Icons.folder_open),
                  onPressed: _selectRootPath,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入网站根目录';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: '网站类型',
                prefixIcon: Icon(Icons.category),
                helperText: _typeDescriptions[_selectedType],
              ),
              items: [
                DropdownMenuItem(
                  value: 'static',
                  child: Text('静态网站'),
                ),
                DropdownMenuItem(
                  value: 'runtime',
                  child: Text('运行环境'),
                ),
                DropdownMenuItem(
                  value: 'app',
                  child: Text('一键部署'),
                ),
                DropdownMenuItem(
                  value: 'proxy',
                  child: Text('反向代理'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                    // 切换类型时重置相关字段
                    _selectedRuntime = null;
                    _selectedRuntimeVersion = null;
                    _selectedApp = null;
                    _selectedProxyTarget = null;
                  });
                }
              },
            ),
            _buildTypeSpecificFields(),
            SizedBox(height: 16),
            ExpansionTile(
              title: Text('高级选项'),
              children: [
                SwitchListTile(
                  title: Text('启用 Gzip'),
                  subtitle: Text('启用 Gzip 压缩以提高传输速度'),
                  value: _enableGzip,
                  onChanged: (value) {
                    setState(() {
                      _enableGzip = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('启用缓存'),
                  subtitle: Text('启用浏览器缓存以提高访问速度'),
                  value: _enableCache,
                  onChanged: (value) {
                    setState(() {
                      _enableCache = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('启用日志'),
                  subtitle: Text('记录网站访问日志'),
                  value: _enableLog,
                  onChanged: (value) {
                    setState(() {
                      _enableLog = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('启用备份'),
              subtitle: Text('定期备份网站数据'),
              value: _enableBackup,
              onChanged: (value) {
                setState(() {
                  _enableBackup = value;
                });
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('启用监控'),
              subtitle: Text('监控网站运行状态'),
              value: _enableMonitor,
              onChanged: (value) {
                setState(() {
                  _enableMonitor = value;
                });
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('启用 IPv6'),
              subtitle: Text('支持 IPv6 访问'),
              value: _enableIPv6,
              onChanged: (value) {
                setState(() {
                  _enableIPv6 = value;
                });
              },
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('启用 FTP'),
              subtitle: Text('创建 FTP 账号用于文件管理'),
              value: _enableFTP,
              onChanged: (value) {
                setState(() {
                  _enableFTP = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _remarkController,
              decoration: InputDecoration(
                labelText: '备注',
                hintText: '请输入备注信息',
                prefixIcon: Icon(Icons.note),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading ? null : _createWebsite,
              child: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : Text('创建'),
            ),
          ],
        ),
      ),
    );
  }
} 

