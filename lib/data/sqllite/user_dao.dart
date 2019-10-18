import 'package:floor/floor.dart';

import '../model/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM UserModel WHERE id = :id')
  Future<UserModel> findUserById(int id);

  @Query('SELECT * FROM UserModel')
  Future<List<UserModel>> findAllUsers();

  @Query('SELECT * FROM UserModel')
  Stream<List<UserModel>> findAllUsersAsStream();

  @Query('SELECT * FROM UserModel WHERE id= :id')
  Future<List<UserModel>> countUserById(int id);

  @insert
  Future<void> insertUser(UserModel user);

  @insert
  Future<void> insertUsers(List<UserModel> users);

  @update
  Future<void> updateUser(UserModel User);

  @update
  Future<void> updateUsers(List<UserModel> user);

  @delete
  Future<void> deleteUser(UserModel user);

  @delete
  Future<void> deleteUsers(List<UserModel> users);
}
