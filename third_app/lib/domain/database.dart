// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'person.dart';
import 'person_dao.dart';

part 'database.g.dart';

@Database(version: 1, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
}
