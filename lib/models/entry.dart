import 'package:objectbox/objectbox.dart';

@Entity()
class EntryDetail {
  String name;
  String lastName;
  int entryAge;
  int id;

  EntryDetail(
      {this.id = 0,
      required this.name,
      required this.lastName,
      required this.entryAge});
}
