import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

import '../loginPages/signIn.dart';
class AkunUser extends StatefulWidget {
  @override
  _AkunUserState createState() => _AkunUserState();
}

class _AkunUserState extends State<AkunUser> {
  startLoading() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute (builder: (context) {
          return Login();
        }),
        (Route<dynamic> route) => false
      );

  }
  @override
  Widget build(BuildContext context) {
    final logOutButton = Container(
      height: 45.0,
      child: Material(
        borderRadius: BorderRadius.circular(24.0),
        shadowColor: Colors.transparent,
        color: Colors.blueGrey.shade400,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.blueGrey.shade400,width: 2.0)
          ),
          
          onPressed: () {startLoading();},
          padding: EdgeInsets.all(12),
          color: Colors.white,
          child: Center(
            child: Text(
              'LOGOUT',
              style: TextStyle(
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
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
              color: Colors.white,
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
                  Image.asset('2.png',width: 70.0,),
                  Icon(Icons.more_vert ,color: Colors.transparent,),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  logOutButton,
                ],
              )
          )
        ],
      )
    );
  }
}