import 'package:flutter/material.dart';

class Items extends StatelessWidget {
  const Items({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    List items = arguments["items"];

    return Scaffold(
      appBar: AppBar(
        title: Text(arguments["title"]),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].toString().split("\n").first),
            onTap: () {
              Navigator.pushNamed(context, "/details", arguments: {
                'desc': items[index].toString().split("\n").last,
                "title": items[index].toString().split("\n").first
              });
            },
          );
        },
        itemCount: items.length,
      ),
    );
  }
}
