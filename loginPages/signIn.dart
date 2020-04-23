import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../default/baseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUp.dart';
import '../frontPages/landingPages.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  List data2;
  bool visible = false ;

  final txtEmail    = TextEditingController();
  final txtPassword = TextEditingController();

  Future userLogin() async{
    // Showing CircularProgressIndicator.
    setState(() {
    visible = true ; 
    });
 
  // Getting value from Controller
  String email = txtEmail.text;
  String password = txtPassword.text;
 
  // Store all data with Param Name.
  var data = {'email': email, 'password' : password};
 
  // Starting Web API Call.
  var response = await http.post(BaseUrl.login, headers: { 'Accept':'application/json','Content-Type':'application/json' }, body: json.encode(data));
  
  var message = jsonDecode(response.body);
  if(message['error'] == 'Your credential is wrong')
  {
    // Showing Alert Dialog with Response JSON Message.
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Login Failed"),
        actions: <Widget>[
          FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
    );
  }
  else if(message['data']['email'] == email){
    var simpanToken = message['meta']['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(message['data']));
    prefs.setString('Token', simpanToken);
    // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (builder: (context) {
          return Landings();
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    final loginButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Colors.blueGrey.shade400,
        color: Colors.blueGrey.shade400,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            userLogin();
          },
          padding: EdgeInsets.all(12),
          color: Colors.blueGrey.shade400,
          child: Center(
            child: Text(
              'LOGIN',
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
            SizedBox(height: 70,),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('logoDofly.png', width: 70.0),
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
                        email,
                        SizedBox(height: 20,),
                        password,
                        SizedBox(height: 40,),
                        Text("Forgot Password?", style: TextStyle(color: Colors.grey),),
                        SizedBox(height: 40,),
                        loginButton,
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'New to User ?',
                              style: TextStyle(fontFamily: 'Montserrat',color: Colors.grey),
                            ),
                            SizedBox(width: 5.0),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUp())
                                );
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.blueGrey.shade700,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            )
                          ],
                        ),

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