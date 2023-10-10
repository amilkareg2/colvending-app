import 'package:flutter/material.dart';
import 'package:namer_app/controler.dart';
import 'package:namer_app/model/Machine.dart';

class PickingDetails extends StatefulWidget {
  final List<Machine> machines;
  final String user;
  final String password;

  PickingDetails(this.user, this.password, {required this.machines});

  @override
  _PickingDetailsState createState() => _PickingDetailsState();
}

class _PickingDetailsState extends State<PickingDetails> {
  late Future<List<Map<String, dynamic>>> data;

  @override
  void initState() {
    super.initState();
    data = fectPicking(widget.user, widget.password, widget.machines);
  }

  @override
  Widget build(BuildContext context) {
    // Sort the data by count

    return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Picking Products'),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    final subList = item['sub'] as List<Map<String, dynamic>>;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        children: [
                          ListTile(
                            title: Row(
                              children: [
                                Expanded(child: Text(item['name'])),
                                Text(item['count'].toString()),
                                SizedBox(
                                    width:
                                        10), // Adjust the spacing between count and icon
                                Icon(Icons.expand_more,
                                    size: 30), // Increase the size of the icon
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                item['expanded'] = !(item['expanded'] ?? false);
                              });
                            },
                          ),
                          if (item['expanded'] ?? false)
                            Column(
                              children: subList
                                  .map((subItem) => ListTile(
                                        title: Row(
                                          children: [
                                            SizedBox(
                                                width:
                                                    16), // Indentation for sub items
                                            Expanded(
                                                child:
                                                    Text(subItem.keys.first)),
                                            Text(subItem.values.first
                                                .toString()),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                            ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return Center(child: const CircularProgressIndicator());
            }),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(primary: Colors.red[300]),
                child: Text('Atras', style: TextStyle(fontSize: 20)),
              ),
            )));
  }
}
