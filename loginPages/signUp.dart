import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../default/baseurl.dart';
import '../default/constan.dart';
import '../frontPages/landingPages.dart';
import 'signUpSecond.dart';
import 'signIn.dart';

class SignUpPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SignUpPage1(),
    );
  }
}
 class SignUpPage1 extends StatefulWidget {
   static String tag = 'signup-page';
   @override
   _SignUpPage1State createState() => _SignUpPage1State();
 }
 
class _SignUpPage1State extends State<SignUpPage1> {
  String _mySelection='1';
  String item='1';
  bool visible = false ;
  final txtName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPhone = TextEditingController();
  final txtPassword = TextEditingController();
  final txtNameCompany = TextEditingController();
  final txtAddress = TextEditingController();
  final txtPhoneCompany = TextEditingController();

  final String url = BaseUrl.url+"typecompany";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      data = resBody['data'];
    });

    print(resBody);

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    // this.getSWData();
    
  }

  Future nextStep() async{
    String namaUser = txtName.text;
    String emailUser = txtEmail.text;
    String passwordUser = txtPassword.text;
    var errorMessage;
    if(namaUser == ""){
      errorMessage = "Isi nama anda !!.";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }
    else if(emailUser == ""){
      errorMessage = "Isi e-Mail baru next";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }
    else if(passwordUser == ""){
      errorMessage = "Isi Password !!.";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPageSecond(namaUser,emailUser,passwordUser))
      );
    }
  }
   
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80.0,
        child: Image.asset('assets/2.png'),
      ),
    );

    final name = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtName,
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtEmail,
    );
    
    final password = TextFormField(
      autofocus: false,
      // initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtPassword,
    );

    final signupButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Colors.greenAccent,
        color: Colors.green,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          onPressed: () {
            nextStep();
          },
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Center(
            child: Text(
              'NEXT',
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
    final backButton = Container(
      height: 40.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.blueGrey,
        color: Colors.blueGrey,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            // Navigator.of(context).pushNamed(LoginP.tag);
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueGrey,
          child: Center(
            child: Text(
              'GO BACK',
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blueGrey[900],
              Colors.blueGrey[700],
              Colors.blueGrey[400]
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 55,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Register", style: TextStyle(color: Colors.white, fontSize: 40),),
                  SizedBox(height: 10,),
                  Text("Poin of Sales", style: TextStyle(color: Colors.white, fontSize: 18),),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(35))
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left:35, right: 35),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 60,),
                        name,
                        SizedBox(height: 20,),
                        email,
                        SizedBox(height: 20,),
                        password,
                        SizedBox(height: 40,),
                        signupButton,

                      //   Text("Continue with social media", style: TextStyle(color: Colors.grey),),
                      //   SizedBox(height: 30,),
                      //   Row(
                      //     children: <Widget>[
                      //       Expanded(
                      //         child: Container(
                      //           height: 50,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(50),
                      //             color: Colors.blue
                      //           ),
                      //           child: Center(
                      //             child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(width: 30,),
                      //       Expanded(
                      //         child: Container(
                      //           height: 50,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(50),
                      //             color: Warnadasar.menuFood
                      //           ),
                      //           child: Center(
                      //             child: Text("Gmail", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}