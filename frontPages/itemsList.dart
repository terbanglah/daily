import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import '../default/constan.dart';
import '../default/baseurl.dart';
import '../default/api.dart';
import 'addDetailsItems.dart';
import 'editDetailsItems.dart';

class ShowItemList extends StatefulWidget {
  @override
  _ShowItemListState createState() => _ShowItemListState();
}

class _ShowItemListState extends State<ShowItemList> {
  String onRefresh;
  String _mySelection;
  String items;
  final txtName = TextEditingController();
  final txtPrice = TextEditingController();
  final txtStok = TextEditingController();
  File _imageFile;

  Future<File> file;
  String status = '';
  String base64Image;
  var loading = false;
    

  List data; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
    setState(() {
      loading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var res = await http.get(BaseUrl.itemList, headers: { 'accept':'application/json','Content-Type':'application/json','Authorization':'Bearer ${stringValue}' });

    setState(() {

      //RESPONSE YANG DIDAPATKAN DARI API TERSEBUT DI DECODE
      var content = json.decode(res.body);
      print(content);
      //KEMUDIAN DATANYA DISIMPAN KE DALAM VARIABLE data, 
      //DIMANA SECARA SPESIFIK YANG INGIN KITA AMBIL ADALAH ISI DARI KEY hasil
      data = content['data'];
      // print(data);
      loading = false;
    });
    return 'success!';
  }

  
  void initState() {
    super.initState();
    this.getData(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffe86f16),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: 
          Text(
            "Item",
            style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: ()async{
              // _onPressAdd();
              String val = await Navigator.push(context, 
              MaterialPageRoute(builder: (context)=>ItemsForm()));
              setState(() {
                val == 'refresh' ? this.getData() : '';
              });
            }
          ),
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: (){
              // showSearch(context: context, delegate: DataSearch());
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
                      onTap: ()async{ 
                        String val = await Navigator.push(context, 
                          MaterialPageRoute(builder: (context)=>ItemsFormEdit(data[index]['id'].toString(), data[index]['inventory_name'], data[index]['price'].toString(), data[index]['stock'].toString(), data[index]['category']['data']['id'].toString(), data[index]['image'].toString()))
                        );
                        setState(() {
                          val == 'refresh' ? this.getData() : '';
                        });
                      },
                      leading: new Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: new NetworkImage(
                                  data[index]['image'].toString())
                                  )
                        )
                      ),
                      
                      title: Text(data[index]['inventory_name'], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,children: <Widget>[ //MENGGUNAKAN COLUMN
                        //DIMANA MASING-MASING COLUMN TERDAPAT ROW
                        Row(
                          children: <Widget>[
                            Text(data[index]['category']['data']['description'], style: TextStyle(fontStyle: FontStyle.italic, fontSize: 15.0),),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            // Text('Rp. ', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Rp. '),
                            //DARI INDEX ayat
                            Text(data[index]['price'].toString())
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            // Text('Rp. ', style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('Stok '),
                            //DARI INDEX ayat
                            Text(data[index]['stock'].toString())
                          ],
                        ),
                      ],),
                      trailing: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.blueGrey.shade700,
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
  
}
  