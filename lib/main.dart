import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'fetch_data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TapGestureRecognizer _recognizer1;

  int current_index;
  List<String> DataWord;
  initData() {
    if (this.mounted) {
      setState(() {
        DataWord = FetchData.ConvertWord(FetchData.data);
      });
    }
  }

  @override
  void initState() {
    initData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Detech word",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.blueGrey,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              child: RichText(
                softWrap: true,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: List.generate(DataWord.length ?? 0, (int index) {
                    return new TextSpan(
                      text: DataWord[index].toString(),
                      children: [
                        TextSpan(
                            text: " ",
                            style: TextStyle(
                              color: Colors.transparent,
                              background: Paint()
                                ..color = Colors.transparent
                                ..strokeWidth = 0
                                ..style = PaintingStyle.stroke,
                            ))
                      ],
                      style: current_index == index
                          ? TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              background: Paint()
                                ..color = Colors.grey[400]
                                ..strokeWidth = 2
                                ..style = PaintingStyle.stroke,
                            )
                          : TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              background: Paint()
                                ..color = Colors.transparent
                                ..strokeWidth = 0.0),
                      recognizer: new TapGestureRecognizer()
                        ..onTap = () {
                          onHandelTap(index);
                        },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onHandelTap(int index) {
    setState(() {
      current_index = index;
    });
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(DataWord[index].toString()),
      duration: Duration(milliseconds: 400),
    ));
  }
}
