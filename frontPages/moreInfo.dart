import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginPages/signIn.dart';
import 'kategori.dart';

class InfoUser extends StatefulWidget {
  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  logOut() async{
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
      final logoutnButton = Container(
      height: 45.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Colors.white,
        color: Colors.blueGrey.shade800,
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: BorderSide(color: Colors.blueGrey.shade800,width: 2.0)
          ),
          onPressed: () {
            logOut();
          },
          padding: EdgeInsets.all(12),
          color: Colors.white,
          child: Center(
            child: Text(
              'Log Out',
              style: TextStyle(
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blueGrey.shade800
        ),
        title: 
          Text('Profil',
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
        ),
      ),
      body: new ListView(
        children: <Widget>[
          ListTile(
            title: 
              Text(
                "Info",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
          ),
          ListTile(
            title: 
              Text(
                'Aktifasi',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            leading: 
              Icon(
                Icons.schedule,
                color: Colors.blueGrey.shade700,
              ),
            trailing: 
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.blueGrey.shade700,
              ),
          ),
          ListTile(
            onTap: (){
              Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>Kategori())
              );
            },
            title: 
              Text(
                'Kategori Menu',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            leading: 
              Icon(
                Icons.book,
                color: Colors.blueGrey.shade700,
              ),
            trailing: 
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.blueGrey.shade700,
              ),
          ),
          ListTile(
            title: 
              Text(
                'Tentang Aplikasi',
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                  color: Colors.blueGrey.shade700,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            leading: 
              Icon(
                Icons.info,
                color: Colors.blueGrey.shade700,
              ),
            trailing: 
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.blueGrey.shade700,
              ),
          ),
          SizedBox(height: 45.0,),
          ListTile(
            title: logoutnButton,
          )
        ],
      ),
    );
  }
}