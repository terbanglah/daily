import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPages/signIn.dart';
import 'frontPages/landingPages.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  cekLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('Token');
    print(stringValue);
    if (stringValue != null){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (builder: (_) {
          // return LandingPages();
          return Landings();
        }),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute (builder: (_) {
          return Login();
          // return landings();
        }),
      );
    }
    // return stringValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cekLogin();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    
    );
  }
}
