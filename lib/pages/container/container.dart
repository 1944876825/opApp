import 'package:flutter/material.dart';
import 'package:op_app/common/api/container.dart';
import 'package:op_app/common/model/container.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  late final Future _init = () async {
    await _getContainerList();
  }();
  List<ContainerItem> _containerList = [];
  _getContainerList() async {
    var res = await ApiContainer.search();
    if (!res.success) {
      return;
    }
    _containerList = res.data!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("容器"),
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
              itemCount: _containerList.length,
              itemBuilder: (context, index) {
                var con = _containerList[index];
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
                            con.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(con.imageName),
                          if (con.network.isNotEmpty)
                            Text(con.network.join(",")),
                          if (con.ports.isNotEmpty) Text(con.ports.join(",")),
                          Text("CPU: 0.09%"),
                          Text("内存: 445 MB"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
