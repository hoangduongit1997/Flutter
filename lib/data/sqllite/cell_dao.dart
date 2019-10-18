import 'package:floor/floor.dart';
import 'package:pika_maintenance/data/model/cell_model.dart';

@dao
abstract class CellDao {
  @Query('SELECT * FROM CellModel WHERE id = :id')
  Future<CellModel> findLinesById(int id);

  @Query('SELECT * FROM CellModel')
  Future<List<CellModel>> findAllLiness();

  @Query('SELECT * FROM CellModel')
  Stream<List<CellModel>> findAllLinessAsStream();

  @Query('SELECT * FROM CellModel WHERE id= :id')
  Future<List<CellModel>> countLinesById(int id);
  @Query('DELETE FROM CellModel')
  Future<void> deleteAllRow();
  @Query('SELECT * from CellModel WHERE wt=(SELECT MAX(wt) FROM CellModel ORDER BY wt DESC LIMIT 1)')
  Future<CellModel> selectMaxWT();
  @insert
  Future<void> insertCellModel(CellModel cellModel);

  @insert
  Future<void> insertCellModels(List<CellModel> cellModel);

  @update
  Future<void> updateCellModel(CellModel cellModel);

  @update
  Future<void> updateCellModels(List<CellModel> cellModel);

  @delete
  Future<void> deleteCellModel(CellModel cellModel);

  @delete
  Future<void> deleteCellModels(List<CellModel> cellModel);
}
