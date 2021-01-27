import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'griddashboard.dart';
import 'moreInfo.dart';

class Landings extends StatefulWidget {
  @override
  _LandingsState createState() => _LandingsState();
}

class _LandingsState extends State<Landings> {
  String nama ="";
  String namaCompany ="";
  userInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringValue = jsonDecode(prefs.getString('user'));
    print(stringValue);
    setState(() {
      nama = stringValue['nama'];
      namaCompany = stringValue['company']['data']['name_company'];
    });
  }
  @override
  void initState() {
    super.initState();
    userInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xff392850),
      backgroundColor: Colors.blueGrey.shade800,
      body:Column(
          children: <Widget>[
            SizedBox(
              height: 110,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        namaCompany,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        nama,
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                color: Color(0xffa29aac),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  IconButton(
                    alignment: Alignment.topCenter,
                    icon: Icon(Icons.more_vert),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InfoUser()),
                      );
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
          GridDashboard()
          ],
      ),
    );
  }
}