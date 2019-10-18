import 'package:floor/floor.dart';
import 'package:pika_maintenance/data/model/message_model.dart';

@dao
abstract class MessageFirebaseDao {
  @Query('SELECT * FROM MessageFirebaseModel WHERE id = :id')
  Future<MessageFirebaseModel> findLinesById(int id);

  @Query('SELECT * FROM MessageFirebaseModel')
  Future<List<MessageFirebaseModel>> findAllMessageFirebases();
  @Query('DELETE FROM MessageFirebaseModel WHERE id=:id')
  Future<void> deleteMessageById(int id);
  @Query('SELECT * FROM MessageFirebaseModel')
  Stream<List<MessageFirebaseModel>> findAllMessageFirebasesAsStream();
  @Query('SELECT * FROM MessageFirebaseModel WHERE id= :id')
  Future<List<MessageFirebaseModel>> countMessageFirebaseById(int id);
  @Query('DELETE FROM MessageFirebaseModel')
  Future<void> deleteAllRow();

  @insert
  Future<void> insertMessageFirebaseModel(MessageFirebaseModel machineModel);

  @insert
  Future<void> insertMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel);

  @update
  Future<void> updateMessageFirebaseModel(MessageFirebaseModel machineModel);

  @update
  Future<void> updateMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel);

  @delete
  Future<void> deleteMessageFirebaseModel(MessageFirebaseModel machineModel);

  @delete
  Future<void> deleteMessageFirebasesModels(
      List<MessageFirebaseModel> machineModel);
}
