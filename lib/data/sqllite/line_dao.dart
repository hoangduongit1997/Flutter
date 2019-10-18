import 'package:floor/floor.dart';
import 'package:pika_maintenance/data/model/line_model.dart';


@dao
abstract class LinesDao {
  @Query('SELECT * FROM LineModel WHERE id = :id')
  Future<LineModel> findLinesById(int id);

  @Query('SELECT * FROM LineModel')
  Future<List<LineModel>> findAllLiness();

  @Query('SELECT * FROM LineModel')
  Stream<List<LineModel>> findAllLinessAsStream();
  @Query('SELECT * from LineModel WHERE wt=(SELECT MAX(wt) FROM LineModel ORDER BY wt DESC LIMIT 1)')
  Future<LineModel> selectMaxWT();
  @Query('SELECT * FROM LineModel WHERE id= :id')
  Future<List<LineModel>> countLinesById(int id);
  @Query('DELETE FROM LineModel')
  Future<void> deleteAllRow();
  @insert
  Future<void> insertLines(LineModel lines);

  @insert
  Future<void> insertLiness(List<LineModel> lines);

  @update
  Future<void> updateLines(LineModel lines);

  @update
  Future<void> updateLiness(List<LineModel> lines);

  @delete
  Future<void> deleteLines(LineModel lines);

  @delete
  Future<void> deleteLiness(List<LineModel> liness);
}
