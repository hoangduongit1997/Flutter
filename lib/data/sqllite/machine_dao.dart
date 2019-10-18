import 'package:floor/floor.dart';
import 'package:pika_maintenance/data/model/machine_model.dart';



@dao
abstract class MachineDao {
  @Query('SELECT * FROM MachineModel WHERE id = :id')
  Future<MachineModel> findLinesById(int id);

  @Query('SELECT * FROM MachineModel')
  Future<List<MachineModel>> findAllMachines();

  @Query('SELECT * FROM MachineModel')
  Stream<List<MachineModel>> findAllMachinesAsStream();
 @Query('SELECT * from MachineModel WHERE wt=(SELECT MAX(wt) FROM MachineModel ORDER BY wt DESC LIMIT 1)')
  Future<MachineModel> selectMaxWT();
  @Query('SELECT * FROM MachineModel WHERE id= :id')
  Future<List<MachineModel>> countMachineById(int id);
  @Query('DELETE FROM MachineModel')
  Future<void> deleteAllRow();
  @insert
  Future<void> insertMachineModel(MachineModel machineModel);

  @insert
  Future<void> insertMachinesModels(List<MachineModel> machineModel);

  @update
  Future<void> updateMachineModel(MachineModel machineModel);

  @update
  Future<void> updateMachinesModels(List<MachineModel> machineModel);

  @delete
  Future<void> deleteMachineModel(MachineModel machineModel);

  @delete
  Future<void> deleteMachinesModels(List<MachineModel> machineModel);
}
