import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:op_app/common/api/app.dart';
import 'package:op_app/common/model/app.dart' as app_model;
import 'package:op_app/common/model/app.dart';

class InstallPage extends StatefulWidget {
  final String appName;
  final String appKey;

  const InstallPage({super.key, required this.appName, required this.appKey});

  @override
  State<InstallPage> createState() => _InstallPageState();
}

class _InstallPageState extends State<InstallPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = true;
  bool _installing = false;
  String? _error;
  app_model.AppInfo? _appInfo;
  app_model.AppDeatil? _appDetail;
  String? _selectedVersion;
  Map<String, dynamic> _formData = {};
  Map<String, List<ServiceItem>> _availableServices = {};

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  Future<void> _fetchAppInfo() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final res = await ApiApp.appInfo(widget.appKey);
      if (res.success && res.data != null) {
        setState(() {
          _appInfo = res.data!;
          _selectedVersion = _appInfo!.versions.first;
        });
        await _fetchAppDetail();
      } else {
        setState(() {
          _error = res.message ?? '获取应用信息失败';
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

  Future<void> _fetchAppDetail() async {
    if (_selectedVersion == null) return;

    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      final res = await ApiApp.appDeatil(_appInfo!.id.toString(), _selectedVersion!);
      if (res.success && res.data != null) {
        setState(() {
          _appDetail = res.data!;
          _formData = {};
          for (var field in _appDetail!.params.formFields) {
            _formData[field.envKey] = field.formFieldDefault;
            if (field.type == 'apps' && 
                field.child != null && 
                field.child!.type == 'service' && 
                field.formFieldDefault != null) {
              _fetchAvailableServices(field.child!.envKey, field.formFieldDefault);
            }
          }
        });
      } else {
        setState(() {
          _error = res.message ?? '获取应用详情失败';
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

  Future<void> _fetchAvailableServices(String key, String dbType) async {
    try {
      final res = await ApiApp.services(dbType);
      if (res.success && res.data != null) {
        print("mydebug services data $key $dbType ${res.data}");
        setState(() {
          _availableServices[key] = res.data!;
          // 如果有服务列表，自动选择第一个可用的服务
          if (res.data!.isNotEmpty) {
            final firstService = res.data!.first;
            _formData[key] = firstService.value;
            // 如果服务有配置信息，自动填充到表单中
            if (firstService.config.isNotEmpty) {
              firstService.config.forEach((key, value) {
                _formData[key] = value;
              });
            }
          }
        });
      }
    } catch (e) {
      print('获取服务列表失败: $e');
    }
  }

  Future<void> _installApp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _installing = true;
      _error = null;
    });

    try {
      // 构建服务映射
      Map<String, String> services = {};
      for (var field in _appDetail!.params.formFields) {
        if (field.child != null && field.child!.type == 'service') {
          services[field.child!.envKey] = _formData[field.child!.envKey] ?? '';
        }
      }

      final res = await ApiApp.install({
        'name': widget.appName,
        'version': _selectedVersion,
        'params': _formData,
        'services': services,
        'appDetailId': _appDetail!.id,
        'advanced': false,
        'allowPort': true,
        'containerName': '',
        'cpuQuota': 0,
        'dockerCompose': _appDetail!.dockerCompose,
        'editCompose': false,
        'gpuConfig': _appDetail!.gpuSupport,
        'hostMode': _appDetail!.hostMode,
        'memoryLimit': 0,
        'memoryUnit': 'MB',
        'pullImage': true
      });

      if (res.success) {
        // 开始监听日志
        final composePath = '/opt/1panel/apps/${widget.appKey}/${widget.appName}/docker-compose.yml';
        print("mydebug composePath $composePath");
        final logStream = ApiApp.getRealtimeLog(composePath);
        
        if (!mounted) return;
        
        // 显示日志对话框
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: Text('安装日志'),
            content: Container(
              width: double.maxFinite,
              height: 400,
              child: StreamBuilder<String>(
                stream: logStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('获取日志失败: ${snapshot.error}');
                  }
                  
                  return SingleChildScrollView(
                    child: SelectableText(
                      snapshot.data ?? '正在等待日志...',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
                child: Text('关闭'),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _error = res.message ?? '安装失败';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _installing = false;
      });
    }
  }

  Widget _buildFormField(app_model.FormField field) {
    final String label = field.labelZh;
    final String type = field.type;
    final bool required = field.required;
    final String envKey = field.envKey;
    final dynamic defaultValue = field.formFieldDefault;

    if (!_formData.containsKey(envKey)) {
      _formData[envKey] = defaultValue;
    }

    switch (type) {
      case 'apps':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _formData[envKey],
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
                helperText: required ? '必填' : null,
              ),
              items: field.values?.map((item) {
                return DropdownMenuItem(
                  value: item.value,
                  child: Text(item.label),
                );
              }).toList(),
              validator: required ? (v) {
                if (v == null || v.isEmpty) return '请选择$label';
                return null;
              } : null,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _formData[envKey] = value;
                    if (field.child != null && field.child!.type == 'service') {
                      _fetchAvailableServices(field.child!.envKey, value);
                    }
                  });
                }
              },
            ),
            if (field.child != null && field.child!.type == 'service') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: field.labelZh,
                    border: const OutlineInputBorder(),
                    helperText: field.child!.required ? '必填' : null,
                  ),
                  value: _formData[field.child!.envKey]?.toString(),
                  isExpanded: true,
                  selectedItemBuilder: (context) {
                    return _availableServices[field.child!.envKey]?.map((service) {
                      return Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              service.from == 'local' ? Icons.check_circle : Icons.error,
                              color: service.from == 'local' ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                service.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList() ?? [];
                  },
                  items: _availableServices[field.child!.envKey]?.map((service) {
                    return DropdownMenuItem<String>(
                      value: service.value,
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 100,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              service.from == 'local' ? Icons.check_circle : Icons.error,
                              color: service.from == 'local' ? Colors.green : Colors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    service.label,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (service.config.isNotEmpty)
                                    Text(
                                      '用户名: ${service.config['PANEL_DB_ROOT_USER'] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList() ?? [],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _formData[field.child!.envKey] = value;
                        // 如果服务有配置信息，自动填充到表单中
                        final service = _availableServices[field.child!.envKey]?.firstWhere(
                          (s) => s.value == value
                        );
                        if (service != null && service.config.isNotEmpty) {
                          service.config.forEach((key, value) {
                            _formData[key] = value;
                          });
                        }
                      });
                    }
                  },
                  validator: field.child!.required
                      ? (value) => value == null ? '请选择${field.child!.envKey}' : null
                      : null,
                ),
              ),
            ],
          ],
        );

      case 'text':
        return TextFormField(
          initialValue: _formData[envKey]?.toString(),
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            helperText: required ? '必填' : null,
          ),
          validator: required ? (v) {
            if (v == null || v.isEmpty) return '请输入$label';
            return null;
          } : null,
          onChanged: (v) => setState(() => _formData[envKey] = v),
        );

      case 'password':
        return TextFormField(
          initialValue: _formData[envKey]?.toString(),
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            helperText: required ? '必填' : null,
          ),
          obscureText: true,
          validator: required ? (v) {
            if (v == null || v.isEmpty) return '请输入$label';
            return null;
          } : null,
          onChanged: (v) => setState(() => _formData[envKey] = v),
        );

      case 'number':
        return TextFormField(
          initialValue: _formData[envKey]?.toString(),
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            helperText: required ? '必填' : null,
          ),
          keyboardType: TextInputType.number,
          validator: required ? (v) {
            if (v == null || v.isEmpty) return '请输入$label';
            if (int.tryParse(v) == null) return '请输入有效的数字';
            return null;
          } : null,
          onChanged: (v) => setState(() => _formData[envKey] = int.tryParse(v) ?? v),
        );

      default:
        return TextFormField(
          initialValue: _formData[envKey]?.toString(),
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            helperText: required ? '必填' : null,
          ),
          validator: required ? (v) {
            if (v == null || v.isEmpty) return '请输入$label';
            return null;
          } : null,
          onChanged: (v) => setState(() => _formData[envKey] = v),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('安装应用'),
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
                        onPressed: _fetchAppInfo,
                        child: Text('重试'),
                      ),
                    ],
                  ),
                )
              : _appInfo == null
                  ? Center(child: Text('应用信息不存在'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
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
                                            base64Decode(_appInfo!.icon),
                                            width: 64,
                                            height: 64,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _appInfo!.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                _appInfo!.type,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_appInfo!.description.isNotEmpty) ...[
                                      SizedBox(height: 16),
                                      Text(
                                        _appInfo!.description,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '安装配置',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    if (_appInfo!.versions.isNotEmpty) ...[
                                      DropdownButtonFormField<String>(
                                        value: _selectedVersion,
                                        decoration: InputDecoration(
                                          labelText: '版本',
                                          border: OutlineInputBorder(),
                                        ),
                                        items: _appInfo!.versions.map((version) {
                                          return DropdownMenuItem(
                                            value: version,
                                            child: Text(version),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedVersion = value;
                                            });
                                            _fetchAppDetail();
                                          }
                                        },
                                      ),
                                      SizedBox(height: 16),
                                    ],
                                    if (_appDetail != null) ...[
                                      for (var field in _appDetail!.params.formFields)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: _buildFormField(field),
                                        ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _installing ? null : _installApp,
                                child: _installing
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text('安装'),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}
