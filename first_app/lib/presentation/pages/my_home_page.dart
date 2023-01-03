import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/data.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Box<Data>? _infoBox;

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(DataAdapter());

    Hive.openBox<Data>('listItems').then((value) {
      setState(() {
        _infoBox = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: _infoBox == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ValueListenableBuilder(
                  valueListenable: _infoBox!.listenable(),
                  builder: (context, Box<Data> box, child) {
                    return ListView.builder(
                      itemBuilder: (_, index) {
                        final item = box.values.elementAt(index);
                        return ListTile(
                          title: Text(item.category),
                          onTap: () {
                            Navigator.pushNamed(context, "/items", arguments: {
                              'items': item.items,
                              "title": item.category
                            });
                          },
                        );
                      },
                      itemCount: box.length,
                    );
                  },
                )),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add category"),
        onPressed: () {
          _infoBox?.add(Data("New category", [
            "First item \n Desc",
            "Second item \n Desc",
            "Third item \n Desc"
          ]));
        },
      ),
    );
  }
}
