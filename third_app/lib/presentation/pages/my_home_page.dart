// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/database.dart';
import '../../domain/person.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

late var storage;
late var database;
late var personDao;

List<Person> persons = [];

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    _initDB();
  }

  void _initDB() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database4.db').build();
    personDao = database.personDao;
    persons = await personDao.findAllPersons();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<void> addUser(int id) async {
      storage?.write(key: id.toString(), value: "1234-123-12321-123");
      var cardNum = await storage!.read(key: id.toString());
      final person = Person(id, "Artem", "Ilinskii", 31,
          "assets/images/person.png", "81233212334", cardNum);
      await database.personDao.insertPerson(person);
      persons = await personDao.findAllPersons();
      setState(() {});
    }

    Future<void> removeUser(Person person) async {
      await personDao.deletePerson(person);
      persons = await personDao.findAllPersons();
      setState(() {});
    }

    Future<void> editUser(int id) async {
      await personDao.updatePerson(Person(id, "name", "family", 11,
          "assets/images/person.png", "12213124", "1234567890"));
      persons = await personDao.findAllPersons();
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                editUser(persons[index].id);
              },
              leading: Image.asset(persons[index].avatar),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  removeUser(persons[index]);
                },
              ),
              title: Text(
                  "${persons[index].name} ${persons[index].family}, Возраст: ${persons[index].age}"),
              subtitle: Text(
                  "Phone: ${persons[index].phone} Card: ${persons[index].cardNum}"),
            ),
          );
        },
        itemCount: persons.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add person"),
        onPressed: () async {
          addUser(Random().nextInt(9999));
        },
      ),
    );
  }
}
