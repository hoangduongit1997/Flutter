import 'package:floor/floor.dart';

@entity
class MessageFirebaseModel {
  @PrimaryKey(autoGenerate: true)
  int id;
  String title;
  String body;
  int status;
  MessageFirebaseModel(this.id, this.title, this.body, this.status);
}
