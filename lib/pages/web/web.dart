import 'package:flutter/material.dart';

import '../../common/api/websites.dart';
import '../../common/model/websites.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final List<WebSiteItem> _webList = [];
  late final Future _init = () async {
    var res = await ApiWebsites.getList();
    if (!res.success) {
      return;
    }
    // _webList = res.data!;
    _webList.addAll(res.data!);
  }();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("网站"),
      ),
      body: FutureBuilder(
          future: _init,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snap.hasError) {
              // throw snap.error!;
              return Center(
                child: Text(snap.error.toString()),
              );
            }
            return ListView.builder(
              itemCount: _webList.length,
              itemBuilder: (context, index) {
                var web = _webList[index];
                return Card(
                    child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    web.appName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(web.alias),
                                  // Text(web.description),
                                  Text("CPU: 0.09%"),
                                ]))));
              },
            );
          }),
    );
  }
}
