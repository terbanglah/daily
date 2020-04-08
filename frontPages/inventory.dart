import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../default/api.dart';
import '../default/constan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

// import 'beranda/berandaAppbar.dart';

class Inventory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AkunUser(),
      // home: LandingPages(),
    );
  }
}

class AkunUser extends StatefulWidget {
  @override
  _AkunUserState createState() => _AkunUserState();
}

class _AkunUserState extends State<AkunUser> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      
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
              color: Warnadasar.white,
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              margin: EdgeInsets.fromLTRB(0,20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.navigate_before,size: 28,color: Colors.transparent,),
                  // Image.asset('logo1.png'),
                  Text("Inventory",style: TextStyle(fontSize: 20,color: Warnadasar.defaultColor, fontWeight: FontWeight.bold),),
                  Icon(Icons.navigate_before,color: Colors.transparent,),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(),
    );
  }

}