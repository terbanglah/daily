import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../default/baseurl.dart';
import '../frontPages/landingPages.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
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

  List data = List();

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

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      padding: EdgeInsets.only(bottom: 10.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blueGrey.shade700 : Colors.blueGrey.shade300,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute (builder: (context) {
          return Landings();
        }),
        (Route<dynamic> route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // stops: [0.4, 0.7, 0.9],
              colors: [
                Colors.blueGrey[900],
                Colors.blueGrey[700],
                Colors.blueGrey[400]
              ],
            ),
          ),
           // padding: EdgeInsets.only(top: 85.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 40,),
                Container(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('logoDofly.png', width: 70.0),
                      // SizedBox(height: 10,),
                      Text("Poin of Sales", style: TextStyle(color: Colors.white, fontSize: 18),),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(35))
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(left:25, right: 25),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 500.0,
                              child: PageView(
                                physics: ClampingScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (int page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top:40.0, left: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 30,),
                                        name,
                                        SizedBox(height: 20,),
                                        email,
                                        SizedBox(height: 20,),
                                        password,
                                        SizedBox(height: 20,),
                                        phone,
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top:40.0, left: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(height: 30,),
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
                                        SizedBox(height: 20,),
                                        nameCompany,
                                        SizedBox(height: 20,),
                                        comapanyPhone,
                                        SizedBox(height: 20,),
                                        address,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: _buildPageIndicator(),
                                ),
                                SizedBox(height: 10.0),
                                Align(
                                alignment: FractionalOffset.center,
                                child: Container(
                                  height: 55.0,
                                  width: (_currentPage == (_numPages - 1)) ? 150 : 55,
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
                                        if(_currentPage== 0){
                                          _pageController.nextPage(
                                            duration: Duration(milliseconds: 500),
                                            curve: Curves.easeInOutQuint);
                                        }else if(_currentPage==1){
                                          Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute (builder: (context) {
                                              return Landings();
                                            }),
                                            (Route<dynamic> route) => false
                                          );
                                        }
                                      },
                                      padding: EdgeInsets.all(12),
                                      color: Colors.blueGrey.shade400,
                                      child: Center(
                                        child: 
                                        (_currentPage == (_numPages - 1))
                                        ?Text(
                                          'Sign Up',
                                          style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                        ):
                                        Icon(
                                            Icons.navigate_next,
                                            size: 35,
                                            color: Colors.white,
                                          ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              ],
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),
                ),  
              ],
            ),
        ),
      ),
    );
  }
}