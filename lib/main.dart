import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final word=WordPair.random();
    return MaterialApp(
      title: 'Random App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random Word'),
        ),
        body: Center(
          child: Randomword(),
        ),
      ),
    );
  }
}
class RandomWordState extends State<Randomword>
{
  @override
  Widget build(BuildContext context) {
    final word=WordPair.random();
    return Text(word.asUpperCase);
  }
}

class Randomword extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RandomWordState();
  }

}

