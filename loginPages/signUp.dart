import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../default/baseurl.dart';
import '../frontPages/landingPages.dart';
import 'signIn.dart';

class SignUpPage extends StatelessWidget {
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
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: SignUpPage1(),
      routes: routes,
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
    this.getSWData();
    
  }

  Future register() async{
    // Showing CircularProgressIndicator.
    setState(() {
    visible = true ; 
    });
 
    var url = BaseUrl.url+'auth/register';
    // Getting value from Controller
    String name = txtName.text;
    String email = txtEmail.text;
    String phone = txtPhone.text;
    String password = txtPassword.text;
    String company = txtNameCompany.text;
    String address = txtAddress.text;
    String phonecompany = txtPhoneCompany.text;
    // Store all data with Param Name.
    var data = {'name': name, 'email'	: email,	'mobile_phone'	: phone,	'password'	: password,	'type_id'		: _mySelection,	'name_company'	: company,	'address'		: address,	'phone_company'	: phonecompany};
  
    // print(data);
    // Starting Web API Call.
    var response = await http.post(url, headers: { 'Accept':'application/json','Content-Type':'application/json' }, body: json.encode(data));
 
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    var errorMessage;
    // print(message);
    if(message['message']=='The given data was invalid.'){
      var data1 = message['errors'];
      if(data1['name'] != null){
        var data2 = data1['name'];
        errorMessage = data2[0];
      }
      else if(data1['mobile_phone'] != null){
        var data2 = data1['mobile_phone'];
        errorMessage = data2[0];
      }
      else if(data1['password'] != null){
        var data2 = data1['password'];
        errorMessage = data2[0];
      }
      else if(data1['password'][0] == 'The password must be at least 8 characters.'){
        var data2 = data1['password'];
        errorMessage = data2[0];
      }
      else if(data1['name_company'] != null){
        var data2 = data1['name_company'];
        errorMessage = data2[0];
      }
      else if(data1['address'] != null){
        var data2 = data1['address'];
        errorMessage = data2[0];
      }
      else if(data1['phone_company'] != null){
        var data2 = data1['phone_company'];
        errorMessage = data2[0];
      }
      else {
        var data2 = data1['email'];
        errorMessage = data2[0];
      }
      // print(errorMessage);
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
  else if(message['data']['email'] == email){
    var simpanToken = message['meta']['token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Token', simpanToken);
    // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Landings())
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

    final phone = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtPhone,
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

    final nameCompany = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Name Company',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtNameCompany,
    );

    final address = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      maxLength: 250,
      decoration: InputDecoration(
        labelText: 'Address',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtAddress,
    );

    final comapanyPhone = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      // initialValue: 'alucard@gmail.com',
      decoration: InputDecoration(
        labelText: 'Company Phone',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
      ),
      controller: txtPhoneCompany,
    );

    final signupButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        shadowColor: Colors.greenAccent,
        color: Colors.green,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {register();},
          padding: EdgeInsets.all(12),
          color: Colors.green,
          child: Center(
            child: Text(
              'SIGN UP',
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
            Navigator.of(context).pushNamed(LoginPage.tag);
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
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  logo,
                  SizedBox(height: 10.0),
                  name,
                  SizedBox(height: 5.0),
                  email,
                  SizedBox(height: 5.0),
                  phone,
                  SizedBox(height: 5.0),
                  password,
                  SizedBox(height: 5.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23.0),
                      border: Border.all(
                      style: BorderStyle.solid, width: 0.80),
                    ),
                    child: DropdownButton(
                      // : txtPhoneCompany,
                      isExpanded: true,
                      items: data.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['description']),
                          value: item['id'].toString(),
                        
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelection = newVal;
                        });
                      },
                      value: _mySelection,
                    )
                  ),
                  SizedBox(height: 5.0),
                  nameCompany,
                  SizedBox(height: 5.0),
                  address,
                  SizedBox(height: 5.0),
                  comapanyPhone,
                  SizedBox(height: 40.0),
                  signupButton,
                  SizedBox(height: 20.0),
                  backButton,
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ]
        )
      );
   }
 }