import 'package:flutter/material.dart';
import '../../common/api/host.dart';
import '../../common/model/host.dart';

class HostFormPage extends StatefulWidget {
  final Host? host;

  const HostFormPage({super.key, this.host});

  @override
  State<HostFormPage> createState() => _HostFormPageState();
}

class _HostFormPageState extends State<HostFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = 'ssh';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.host != null) {
      _nameController.text = widget.host!.name;
      _addressController.text = widget.host!.address;
      _portController.text = widget.host!.port.toString();
      _usernameController.text = widget.host!.username;
      _passwordController.text = widget.host!.password;
      _descriptionController.text = widget.host!.description;
      _type = widget.host!.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _testConnection() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await ApiHost.testConnection({
        'address': _addressController.text,
        'port': int.parse(_portController.text),
        'username': _usernameController.text,
        'password': _passwordController.text,
        'type': _type,
      });

      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('连接测试成功')),
        );
      } else {
        setState(() {
          _error = res.message ?? '连接测试失败';
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = {
        'name': _nameController.text,
        'address': _addressController.text,
        'port': int.parse(_portController.text),
        'username': _usernameController.text,
        'password': _passwordController.text,
        'type': _type,
        'description': _descriptionController.text,
      };

      final res = widget.host == null
          ? await ApiHost.create(data)
          : await ApiHost.update(widget.host!.id, data);

      if (res.success) {
        Navigator.pop(context, true);
      } else {
        setState(() {
          _error = res.message ?? '保存失败';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.host == null ? '添加主机' : '编辑主机'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _save,
            child: Text('保存'),
          ),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '名称',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入名称';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: '地址',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入地址';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _portController,
                    decoration: InputDecoration(
                      labelText: '端口',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入端口';
                      }
                      if (int.tryParse(value) == null) {
                        return '请输入有效的端口号';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: '用户名',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入用户名';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: '密码',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '请输入密码';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: InputDecoration(
                      labelText: '类型',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'ssh',
                        child: Text('SSH'),
                      ),
                      DropdownMenuItem(
                        value: 'telnet',
                        child: Text('Telnet'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _type = value;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: '描述',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _loading ? null : _testConnection,
                    icon: Icon(Icons.link),
                    label: Text('测试连接'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 