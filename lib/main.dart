import 'package:flutter/material.dart';
import 'package:op_app/pages/app/apps_installed.dart';
import 'package:op_app/pages/container/container.dart';
import 'package:op_app/pages/dashboard/dashboard.dart';
import 'package:op_app/pages/host/host_list.dart';
import 'package:op_app/pages/web/web.dart';
import 'package:op_app/pages/ssh/ssh_terminal.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      home: const BasePage(),
    );
  }
}

class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          DashBoardPage(),
          AppPage(),
          WebPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "仪表盘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: "应用"),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: "网站"),
        ],
      ),
    );
  }
}
