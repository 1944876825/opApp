import 'package:flutter/material.dart';
import 'package:op_app/pages/app/app.dart';
import 'package:op_app/pages/container/container.dart';
import 'package:op_app/pages/dashboard/dashboard.dart';
import 'package:op_app/pages/web/web.dart';

void main() {
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
        children: [
          DashBoardPage(),
          AppPage(),
          WebPage(),
          ContainerPage(),
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
        // unselectedIconTheme: IconThemeData(
        //   color: Colors.grey,
        // ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12,
        ),
        // selectedIconTheme: IconThemeData(
        //   color: Theme.of(context).colorScheme.primary,
        // ),
        selectedLabelStyle: TextStyle(
          // color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
        ),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "仪表盘"),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: "应用"),
          BottomNavigationBarItem(icon: Icon(Icons.web), label: "网站"),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: "容器"),
        ],
      ),
    );
  }
}
