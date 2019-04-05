import 'dart:convert';
import 'package:basic_app/config.dart';
import 'package:http/http.dart' as http;
class Datamodel {
  final String name;
  final String job;
  final String platform;
  final int age;
  final String link;
  final String linkflutter;
  final String linkvideo;
  final String linkintro;
  final String game;
  Datamodel({this.name, this.job, this.platform,this.age, this.link,
    this.linkflutter, this.linkvideo, this.linkintro,this.game});
  factory Datamodel.fromJson(Map<String, dynamic> json) {
    return Datamodel(
      name:json['name'],
      job:json['job'],
      platform:json['Platform'],
      age:json['Age'],
      link:json['link'],
      linkflutter:json['linkflutter'],
      linkvideo:json['linkvideo'],
      linkintro:json['linkintro'],
      game: json['game']['html5']
    );
  }
}
Future<Datamodel> fetchData() async {
  final response = await http.get(Config.api.trim().toString());
  if (response.statusCode == 200) {
    return Datamodel.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed');
  }
}