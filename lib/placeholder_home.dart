
import 'package:dashboard/slide_recipes.dart';
import 'package:flutter/material.dart';

class PlaceholderMainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 0,0,0),
        constraints: BoxConstraints.expand(),
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: Text("All Recipes", style: TextStyle(
                    fontFamily: 'Raleway',fontSize: 20,color: Colors.brown
                ),),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child:Container(
                    height: 20.0,
                    padding: const EdgeInsets.only(left: 5.0,right: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Recipes of the week", style: TextStyle(
                          fontFamily: 'Raleway',fontSize: 17,color: Colors.brown,
                        ),),
                        Text("See all",style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )

              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child:Center(
                    child: SizedBox(
                        width: double.infinity,
                        height: 200,
                        child:Center(
                          child:CarouselDemo(),
                        )

                    ) ,
                  )

              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child:Container(
                    height: 20.0,
                    padding: const EdgeInsets.only(left: 5.0,right: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Appetizer", style: TextStyle(
                          fontFamily: 'Raleway',fontSize: 17,color: Colors.brown,
                        ),),
                        Text("See all",style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  color: Colors.brown,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child:Container(
                    height: 20.0,
                    padding: const EdgeInsets.only(left: 5.0,right: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Main diskes", style: TextStyle(
                          fontFamily: 'Raleway',fontSize: 17,color: Colors.brown,
                        ),),
                        Text("See all",style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,0),
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  color: Colors.black,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0,10,0,0),
                  child:Container(
                    height: 20.0,
                    padding: const EdgeInsets.only(left: 5.0,right: 20.0),
                    decoration: BoxDecoration(
                        border: Border(
                            left: BorderSide(
                              color: Colors.redAccent,
                              width: 2.0,
                            )
                        )
                    ),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Soup", style: TextStyle(
                          fontFamily: 'Raleway',fontSize: 17,color: Colors.brown,
                        ),),
                        Text("See all",style: TextStyle(fontSize: 15,color: Colors.redAccent,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  )

              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,10,0,10),
                child: Container(
                  height: 200.0,
                  width: double.infinity,
                  color: Colors.green,
                ),
              )
            ],
          ),
        )


    );
  }
}