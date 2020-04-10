import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../default/constan.dart';
import 'beranda/berandaViews.dart';
import 'moreInfo.dart';

class Landings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: showlanding(),
    );
  }
}

class showlanding extends StatefulWidget {
  @override
  _showlandingState createState() => _showlandingState();
}

class _showlandingState extends State<showlanding> {
  List<Widget> _container =[
    new BerandaView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black12,
              spreadRadius: 5,
              blurRadius: 2
            )]
          ),
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade600,
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Container(
              padding: EdgeInsets.only(left: 20.0,top: 20.0, right: 20.0),
              margin: EdgeInsets.fromLTRB(0,20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.navigate_before,size: 28,color: Colors.transparent,),
                  Image.asset('1.png',width: 70.0,),
                  // Text("Doffly",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                  new GestureDetector(
                    onTap:() {
                      Navigator.push(
                        context,
                          MaterialPageRoute(builder: (context) => AkunUser())
                      );
                    },
                    child :new Icon(Icons.more_vert ,color: Colors.white,),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: _container[0],
      );
  }
}