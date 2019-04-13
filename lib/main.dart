
import 'package:dashboard/placeholder.dart';
import 'package:dashboard/placeholder_home.dart';
import 'package:flutter/material.dart';

void main() => runApp(DashBoard());

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.redAccent
      ),
      title: 'My Flutter App',
      home: Home(),
    );
  }
}
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderMainWidget(),
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.green),
    PlaceholderWidget(Colors.black),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.format_list_bulleted),color: Colors.brown,splashColor: Colors.brown,onPressed: onpresssetting,),
          IconButton(icon: Icon(Icons.search),color: Colors.brown,splashColor: Colors.brown,onPressed: onpresssetting,)
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.today),
              title: Text('Shopping List')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('More')
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onpresssetting() {
  }
}