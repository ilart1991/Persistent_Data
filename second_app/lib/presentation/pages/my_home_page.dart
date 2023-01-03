import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

List images = [];

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Image.file(images[index]),
          );
        },
        itemCount: images.length,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
            controller: controller,
            decoration: InputDecoration(
                hintText: "Ссылка на изображение",
                suffix: MaterialButton(
                  onPressed: () async {
                    var response = await http.get(Uri.parse(controller.text));
                    Directory directory =
                        await getApplicationDocumentsDirectory();
                    File file = File(path.join(
                        directory.path, path.basename(controller.text)));
                    await file.writeAsBytes(response.bodyBytes);
                    images.add(file);
                    controller.clear;
                    setState(() {});
                  },
                  child: const Text("Сохранить"),
                ))),
      ),
    );
  }
}
