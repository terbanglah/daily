import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../default/baseurl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signUp.dart';
import '../frontPages/landingPages.dart';
import '../default/api.dart';

class Login extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    SignUpPage1.tag: (context) => SignUpPage(),
    // HomePage1.tag: (context) => HomePage(),
  };
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kodeversitas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Nunito',
      ),
      
      home: LoginPage(),
      routes: routes,
    );
  }
}

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  List data2;
  bool visible = false ;
  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();

  cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Token');
    print(stringValue);
    if (stringValue != null){
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute (builder: (_) {
      //     // return LandingPages();
      //     return LandingPages();
      //   }),
      // );
    }else{

    }
    // return stringValue;
  }

  void initState(){
    super.initState();
    cekLogin();
  }

  Future userLogin() async{
    // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });
 
  // Getting value from Controller
  String email = txtEmail.text;
  String password = txtPassword.text;
 
  // SERVER LOGIN API URL
  // var url='http://192.168.43.100:8080/beckend-daily/public/api/auth/login';
  // var url='http://10.209.47.70:8080/beckend-daily/public/api/auth/login';
 
  // Store all data with Param Name.
  var data = {'email': email, 'password' : password};
 
  // Starting Web API Call.
  var response = await http.post(BaseUrl.login, headers: { 'Accept':'application/json','Content-Type':'application/json' }, body: json.encode(data));
//  print(response.body);
  // Getting Server response into variable.
  var message = jsonDecode(response.body);
  // var data1 = message['data'];
  // print(data1['id']);
  // print(message);
  // If the Response Message is Matched.
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
    final logo = Hero(
      tag: 'hero',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 60.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
        labelText: 'Email',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),

        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.blue))
        ),
      controller: txtEmail,
    );

    final password = TextFormField(
      autofocus: false,
      // initialValue: 'some password',
      obscureText: true,
      decoration: InputDecoration(
        // hintText: 'Password',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
        labelText: 'Password',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.green))
      ),
      controller: txtPassword,
    );
    final loginButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Color(0xff5e72e4),
        color: Color(0xff5e72e4),
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            userLogin();
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute (builder: (context) {
            //     return Landings();
            //   }),
            // );
          },
          padding: EdgeInsets.all(12),
          color: Color(0xff5e72e4),
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

    // final forgotLabel = FlatButton(
    //   child: Text(
    //     'Forgot password?',
    //     style: TextStyle(color: Colors.black54),
    //   ),
    //   onPressed: () {},
    // );
    final forgotLabel = Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.only(top: 15.0, left: 20.0),
      child: FlatButton(
        child: Text(
          'Forgot Password',
          style: TextStyle(
          color: Color(0xff5e72e4),
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
          decoration: TextDecoration.underline),
        ),
        onPressed: (){},
      ),
    );

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  logo,
                  SizedBox(height: 48.0),
                  email,
                  SizedBox(height: 20.0),
                  password,
                  SizedBox(height: 2.0),
                  forgotLabel,
                  SizedBox(height: 40.0),
                  loginButton,
                  SizedBox(height: 15.0),
                  // register,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New to User ?',
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      SizedBox(width: 5.0),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(SignUpPage1.tag);
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Color(0xff5e72e4),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  )

                ],
              ),
            ),
          ],
        ),
    );
  }
}