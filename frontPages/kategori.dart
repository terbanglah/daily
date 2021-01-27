import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../default/baseurl.dart';


class Kategori extends StatefulWidget {
  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  final txtName = TextEditingController();
  List data;

  Future<String> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var res = await http.get(BaseUrl.url + "category", headers: { 'accept':'application/json','Content-Type':'application/json','Authorization':'Bearer ${stringValue}' });

    setState(() {
      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      // print(content);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      data = content['data'];
      print(data);
    });
    return 'success!';
  }

  void initState() {
    super.initState();
    this.getData(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  } 

  Future simpanKategori() async{
    setState(() {
    });
    String name = txtName.text;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var data = {'description': name};
  
    var response = await http.post(BaseUrl.url + "category", headers: { 'accept':'application/json','Content-Type':'application/json','Authorization':'Bearer ${stringValue}' }, body: json.encode(data));

    // print(path.basename(_imageFile.path));
    var message = jsonDecode(response.body);
    print(message);
    setState(() {
        getData();
    });
  }

  Future updtaeKategori(int id) async{
    setState(() {
    });
    String name = txtName.text;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var data = {'description': name};
  
    var response = await http.put(BaseUrl.url + "category/${id}", headers: { 'accept':'application/json','Content-Type':'application/json','Authorization':'Bearer ${stringValue}' }, body: json.encode(data));

    // print(path.basename(_imageFile.path));
    var message = jsonDecode(response.body);
    print(message);
    setState(() {
        getData();
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blueGrey.shade800
        ),
        title: 
          Text(
            "Kategori Menu",
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: (){
              _onPressAdd();
            }
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0, bottom: 10.0), //SET MARGIN DARI CONTAINER
          // padding: EdgeInsets.only(bottom: 50.0),
          child: ListView.builder( //MEMBUAT LISTVIEW
            padding: EdgeInsets.only(bottom: 60.0),
            itemCount: data == null ? 0:data.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
            itemBuilder: (BuildContext context, int index) { 
              return Container(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ListTile(
                      leading: Text(
                        data[index]['description'], 
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                          color: Colors.blueGrey.shade700,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )
                      ),),
                      trailing: IconButton(
                        icon: Icon(Icons.create), 
                        onPressed: (){
                          _onPressEdit(index, data[index]['id']);
                        }
                      ),
                    ),
                    
                  ],),
                )
              );
            },
          ),
      ),
    );
  }

  void _onPressAdd(){
    final invName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'kategori',
        labelStyle: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          borderSide: BorderSide(color: Colors.blueGrey.shade800),)
      ),
      controller: txtName,
    );
    txtName.text = "";
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Tambah Kategori",
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 100.0,
                width: 300.0,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          invName,
                          SizedBox(height: 10.0,),
                        ]
                      )
                    ),
                    
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Color(0xff14639e),
              onPressed: () {
                Navigator.of(context).pop();
                simpanKategori();
                getData();
              },
              child: Text(
                'Simpan',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
                              
  }

  void _onPressEdit(int index, int id){
    final invName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'kategori',
        labelStyle: GoogleFonts.openSans(
          textStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          borderSide: BorderSide(color: Colors.blueGrey.shade800),)
      ),
      controller: txtName,
    );
    
    txtName.text = data[index]['description'];
    //print(_mySelection);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Edit Kategori",
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 100.0,
                width: 300.0,
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          invName,
                          SizedBox(height: 10.0,),
                        ]
                      )
                    ),
                    
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Color(0xff14639e),
              onPressed: () {
                Navigator.of(context).pop();
                updtaeKategori(id);
                getData();
              },
              child: Text(
                'Simpan',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
                              
  }

}