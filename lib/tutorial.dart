import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

void main() => runApp(new Tutorial());

class Tutorial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MySplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MySplashScreen extends StatefulWidget {
  MySplashScreen({Key key}) : super(key: key);

  @override
  MySplashScreenState createState() => new MySplashScreenState();
}

// Custom config
class MySplashScreenState extends State<MySplashScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
    slides.add(
      new Slide(
//        title:
//        'Welcome to CaCook!',
        maxLineTitle: 2,
        styleTitle: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
//        description:
//            "hh",
        styleDescription: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        marginDescription:
        EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
        centerWidget: Padding(
            padding: const EdgeInsets.fromLTRB(30,0,30,10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              Container(
              width: 280.0,
              height: 400.0,
              child: RaisedButton(
                shape:  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                color: Colors.white,
                onPressed: (){},
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,100,0,0),
                      child: Text('Welcome to CaCook!', style: TextStyle(color: Colors.brown,fontSize: 20.0,fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,100),
                      child: Text('The best guides to make a masterchef!', style: TextStyle(color: Colors.brown[300],fontSize: 12.0,fontWeight: FontWeight.normal),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/iconBep.png',height: 80,width: 80,),
                    ),
                  ],
                ),
              ),)
              ],
            )
        ),
        colorBegin: Color(0xffFFDAB9),
        colorEnd: Color(0xff40E0D0),
        backgroundImage: 'assets/background.png',
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {},
      ),
    );
//    slides.add(
//      new Slide(
//        title: "MUSEUM",
//        styleTitle: TextStyle(
//            color: Color(0xffD02090),
//            fontSize: 30.0,
//            fontWeight: FontWeight.bold,
//            fontFamily: 'RobotoMono'),
//        description:
//        "Ye indulgence unreserved connection alteration appearance",
//        styleDescription: TextStyle(
//            color: Color(0xffD02090),
//            fontSize: 20.0,
//            fontStyle: FontStyle.italic,
//            fontFamily: 'Raleway'),
//        pathImage: "assets/photo_museum.png",
//        colorBegin: Color(0xffFFFACD),
//        colorEnd: Color(0xffFF6347),
//        directionColorBegin: Alignment.topRight,
//        directionColorEnd: Alignment.bottomLeft,
//      ),
//    );
    slides.add(
      new Slide(
        title: "COFFEE",
        styleTitle: TextStyle(
            color: Color(0xffD02090),
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono'),
        description:
            "CaCook",
        styleDescription: TextStyle(
            color: Color(0xffD02090),
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
            fontFamily: 'Raleway'),
        pathImage: "assets/photo_coffee_shop.png",
        colorBegin: Color(0xffFFA500),
        colorEnd: Color(0xff7FFFD4),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        maxLineTextDescription: 3,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
  }

  Widget renderNextBtn() {
    return Icon(
      Icons.navigate_next,
      color: Colors.brown,
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return Icon(
      Icons.done,
      color: Colors.red,
    );
  }

  Widget renderSkipBtn() {
    return Icon(
      Icons.skip_next,
      color: Colors.brown,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      // List slides
      slides: this.slides,

      // Skip button
//      renderSkipBtn: this.renderSkipBtn(),
//      colorSkipBtn: Color(0x33000000),
//      highlightColorSkipBtn: Color(0xff000000),

      // Next button
//      renderNextBtn: this.renderNextBtn(),

      // Done button
      renderDoneBtn: this.renderDoneBtn(),
      onDonePress: this.onDonePress,
      colorDoneBtn: Color(0x33000000),
      highlightColorDoneBtn: Color(0xff000000),

      // Dot indicator
      colorDot: Colors.white,
      colorActiveDot: Colors.orangeAccent,
      sizeDot: 13.0,

      // Locale
      locale: 'en',

      // Show or hide status bar
      shouldHideStatusBar: true,
    );
  }
}