import 'package:floor/floor.dart';

@entity
class UserModel {
  @PrimaryKey(autoGenerate: false)
  int id;
  String userCode;
  String userName;
  String fullName;
  String centerCode;
  String roleID;
  String roleName;
  String url_avt;

  UserModel(
    this.id,
    this.userCode,
    this.userName,
    this.fullName,
    this.centerCode,
    this.roleID,
    this.roleName,
    this.url_avt,
  );

  static UserModel fromJson(Map<String, dynamic> json) {
    var results = json['data']['userInfo'];
    UserModel user = new UserModel(
      results['id'] == null ? null : results['id'] as int,
      results['userCode'] == null ? "" : results['userCode'] as String,
      results['userName'] == null ? "" : results['userName'] as String,
      results['fullName'] == null ? "" : results['fullName'] as String,
      results['centerCode'] == null ? "" : results['centerCode'] as String,
      results['roleID'] == null ? "" : results['roleID'] as String,
      results['roleName'] == null ? "" : results['roleName'] as String,
      results['url_avt'] == null ? "" : results['url_avt'] as String,
    );

    return user;
  }
}
