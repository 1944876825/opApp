import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:op_app/common/widgets/message.dart';
import 'package:xterm/xterm.dart';
import 'dart:typed_data';
import 'dart:convert';

class SSHTerminalPage extends StatefulWidget {
  const SSHTerminalPage({super.key});

  @override
  State<SSHTerminalPage> createState() => _SSHTerminalPageState();
}

class _SSHTerminalPageState extends State<SSHTerminalPage> {
  final _hostController = TextEditingController(text: '127.0.0.2');
  final _portController = TextEditingController(text: '22');
  final _usernameController = TextEditingController(text: 'root');
  final _passwordController = TextEditingController(text: '123456');
  final _terminal = Terminal();
  SSHClient? _client;
  SSHSession? _session;
  bool _isConnected = false;
  bool _isLoading = false;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _terminal.onOutput = (data) {
      if (_session != null) {
        _session!.write(Uint8List.fromList(data.codeUnits));
      }
    };
  }

  @override
  void dispose() {
    _disposed = true;
    _disconnect();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    if (_isConnected) return;

    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final port = int.tryParse(_portController.text) ?? 22;
      _client = SSHClient(
        await SSHSocket.connect(_hostController.text, port),
        username: _usernameController.text,
        onPasswordRequest: () => _passwordController.text,
      );

      _session = await _client!.shell(
        pty: SSHPtyConfig(
          width: 80,
          height: 24,
        ),
      );

      _session!.stdout.listen((data) {
        if (!mounted || _disposed) return;
        _terminal.write(utf8.decode(data, allowMalformed: true));
      });

      _session!.stderr.listen((data) {
        if (!mounted || _disposed) return;
        _terminal.write('错误: ${utf8.decode(data, allowMalformed: true)}');
      });

      if (!mounted || _disposed) return;
      setState(() {
        _isConnected = true;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _disposed) return;
      setState(() {
        _isLoading = false;
      });
      showErrorMessage(context, '连接失败: $e');
    }
  }

  Future<void> _disconnect() async {
    if (!_isConnected) return;

    try {
      _session?.close();
      _client?.close();
    } catch (e) {
      if (mounted && !_disposed) {
        showErrorMessage(context, '断开连接失败: $e');
      }
    } finally {
      if (!mounted || _disposed) return;
      setState(() {
        _isConnected = false;
        _client = null;
        _session = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SSH 终端'),
        actions: [
          if (_isConnected)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _terminal.write('\x1b[2J\x1b[H'); // ANSI clear screen
              },
            ),
        ],
      ),
      body: Column(
        children: [
          if (!_isConnected)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _hostController,
                    decoration: const InputDecoration(
                      labelText: '主机',
                      hintText: '输入主机地址',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: '端口',
                      hintText: '输入端口号',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      hintText: '输入用户名',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '密码',
                      hintText: '输入密码',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _connect,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('连接'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(8.0),
              child: TerminalView(
                _terminal,
                autofocus: true,
                backgroundOpacity: 1.0,
                textStyle: const TerminalStyle(
                  fontSize: 14,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 
