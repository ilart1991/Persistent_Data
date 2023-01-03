import 'package:hive/hive.dart';
part 'data.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  List items;

  Data(this.category, this.items);
}
