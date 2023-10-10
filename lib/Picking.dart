import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:namer_app/PickingDetails.dart';
import 'package:namer_app/controler.dart';
import 'package:namer_app/model/Machine.dart';

class Picking extends StatefulWidget {
  final List<Machine> machineData;
  final String user;
  final String password;

  Picking(this.machineData, this.user, this.password);

  @override
  PickingState createState() => PickingState();
}

class PickingState extends State<Picking> {
  late List<Map<String, dynamic>> _categories;

  Set<String> dropDown = {};
  Set<String> machines = {};

  @override
  void initState() {
    super.initState();
    Map<String, List<String>> aux = {};
    for (Machine a in widget.machineData) {
      if (!aux.containsKey(a.mgName)) {
        aux[a.mgName] = [];
      }
      aux[a.mgName]?.add(a.miAlias);
    }
    _categories = aux.entries
        .map((e) => {"name": e.key, "subcategories": e.value})
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final categoryName = category['name'];
              final subcategories = category['subcategories'];
              final isSelected = List<String>.from(subcategories)
                  .where((e) => !machines.contains(e))
                  .isEmpty;

              return ExpansionTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            for (String a in List<String>.from(subcategories)) {
                              if (!isSelected) {
                                machines.add(a);
                              } else {
                                machines.remove(a);
                              }
                            }
                          });
                        },
                      ),
                      Text(categoryName,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  onExpansionChanged: (bool expanded) {
                    if (expanded) {
                      setState(() {
                        dropDown.add(categoryName);
                      });
                    } else {
                      setState(() {
                        dropDown.remove(categoryName);
                      });
                    }
                  },
                  initiallyExpanded: dropDown.contains(categoryName),
                  children: [
                    Column(
                      children: subcategories
                          .map<Widget>((subcategory) => Padding(
                                padding: const EdgeInsets.only(left: 40),
                                child: Row(children: [
                                  Checkbox(
                                    value: machines.contains(subcategory),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (machines.contains(subcategory)) {
                                          machines.remove(subcategory);
                                        } else {
                                          machines.add(subcategory);
                                        }
                                      });
                                    },
                                  ),
                                  Text(subcategory)
                                ]),
                              ))
                          .toList(),
                    ),
                  ]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Print selected categories and subcategories
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PickingDetails(
                          widget.user, widget.password,
                          machines: widget.machineData
                              .where((element) =>
                                  machines.contains(element.miAlias))
                              .toList())));
                },
                child: Text('Picking', style: TextStyle(fontSize: 20)),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final confirmed = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirmacion'),
                      content: Text('¿Estas seguro que deseas continuar?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    await llene(
                      widget.user,
                      widget.password,
                      widget.machineData
                          .where(
                              (element) => machines.contains(element.miAlias))
                          .toList(),
                    );
                    setState(() {
                      if (confirmed == true) {
                        // Show the toast
                        Fluttertoast.showToast(
                          msg: "Accion Completada!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                        );
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                child:
                    Text('LLene la maquina(s)', style: TextStyle(fontSize: 20)),
              )),
        ),
      ],
    );
  }
}
