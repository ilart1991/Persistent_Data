import 'package:floor/floor.dart';

@entity
class Person {
  @primaryKey
  final int id;

  final String name;
  final String family;
  final int age;
  final String avatar;
  final String phone;
  final String cardNum;

  Person(this.id, this.name, this.family, this.age, this.avatar, this.phone,
      this.cardNum);
}
