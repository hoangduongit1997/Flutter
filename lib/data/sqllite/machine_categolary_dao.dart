import 'package:floor/floor.dart';
import 'package:pika_maintenance/data/model/machine_categolary_model.dart';

@dao
abstract class MachineCategolaryDao {
  @Query('SELECT * FROM MachineCategolaryModel WHERE id = :id')
  Future<MachineCategolaryModel> findMachineCategolaryModelById(int id);

  @Query('SELECT * FROM MachineCategolaryModel')
  Future<List<MachineCategolaryModel>> findAllMachineCategolaryModel();

  @Query('SELECT * FROM MachineCategolaryModel')
  Stream<List<MachineCategolaryModel>> findAllMachineCategolaryModelAsStream();
  @Query(
      'SELECT * from MachineCategolaryModel WHERE wt=(SELECT MAX(wt) FROM MachineCategolaryModel ORDER BY wt DESC LIMIT 1)')
  Future<MachineCategolaryModel> selectMaxWT();
  @Query('SELECT * FROM MachineCategolaryModel WHERE id= :id')
  Future<List<MachineCategolaryModel>> countMachineCategolaryModelById(int id);
  @Query('DELETE FROM MachineCategolaryModel')
  Future<void> deleteAllRow();
  @insert
  Future<void> insertMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel);

  @insert
  Future<void> insertMachineCategolaryModels(
      List<MachineCategolaryModel> machineCategolaryModel);

  @update
  Future<void> updateMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel);

  @update
  Future<void> updateMachineCategolaryModels(
      List<MachineCategolaryModel> machineCategolaryModel);

  @delete
  Future<void> deleteMachineCategolaryModel(
      MachineCategolaryModel machineCategolaryModel);

  @delete
  Future<void> deleteMachineCategolaryModels(
      List<MachineCategolaryModel> machineModel);
}
