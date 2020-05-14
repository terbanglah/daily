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

class ItemsForm extends StatefulWidget {
  
  @override
  _ItemsFormState createState() => _ItemsFormState();
}

class _ItemsFormState extends State<ItemsForm> {
  var selectedCard = 'WEIGHT';
  String _mySelection='1';
  String items;
  final txtName = TextEditingController();
  final txtPrice = TextEditingController();
  final txtStok = TextEditingController();
  File _image;

  List dataKategori = List();
    Future<String> getCategoryData() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String stringValue = prefs.getString('Token');
      var res = await http
          .get(Uri.encodeFull(BaseUrl.categoriList), headers: {"Accept": "application/json","Content-Type":"application/json","Authorization":"Bearer ${stringValue}" });
      var resBody = json.decode(res.body);

      setState(() {
        dataKategori = resBody['data'];
      });
      // print(res.body);
      // print(resBody);

      return "Sucess";
    }

  @override
  void initState() {
    super.initState();
    this.getCategoryData();
  }

  Future simpanInv() async{
    // Showing CircularProgressIndicator.
    setState(() {
    });

    // FocusScope.of(context).requestFocus(FocusNode());
    try {
      var request = await CallApi().postDataFile('inventory');
      request.headers.addAll(await CallApi().setHeader());
      request.fields['category_id'] = _mySelection;
      request.fields['inventory_name'] = txtName.text;
      request.fields['price'] = txtPrice.text;
      request.fields['stock'] = txtStok.text;
      print(_mySelection);
      if (_image != null) {
        var stream =
            http.ByteStream(DelegatingStream.typed(_image.openRead()));
        var length = await _image.length();
        request.files.add(http.MultipartFile('image', stream, length,
            filename: path.basename(_image.path)));
      }
      // print(path.basename(_imageFile.path));
      var response = await request.send();
      // print(response.statusCode);
      if (response.statusCode > 2) { //response status 201 (created)
        var body = json.decode(await response.stream.bytesToString());
        if (body['data'] != null) {
          // SharedPreferences localStorage =
          //     await SharedPreferences.getInstance();
          // localStorage.setString('user', json.encode(body['data']));
          print('File Uploaded');
          Navigator.pop(context, 'refresh' );
          // _showMsg('Berhasil Disimpan');
        } else {
          print(body);
          // _showMsg('Gagal Disimpan !');
        }
      } else {
        print('Gagal Disimpan !');
        // _showMsg('');
      }
    } catch (e) {
      debugPrint('Error : $e');
      // _showMsg('Error');
    }

  }

  @override
  Widget build(BuildContext context) {
    final invName = TextFormField(
      autofocus: false,
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
    final harga = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
          ),
        labelText: 'Harga',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
      ),
      controller: txtPrice,
    );
    final stok = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0)
        ),
        labelText: 'Stok',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
      ),
      controller: txtStok,
    );

    final loginButton = Container(
      height: 55.0,
      child: Material(
        borderRadius: BorderRadius.circular(32.0),
        shadowColor: Color(0xffe86f16),
        color: Color(0xffe86f16),
        elevation: 7.0,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () {
            simpanInv();
          },
          padding: EdgeInsets.all(12),
          color: Color(0xffe86f16),
          child: Center(
            child: Text(
              'SIMPAN',
              style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
            ),
          ),
        ),
      ),
    );

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
          print('Image Path $_image');
      });
    }

    
    return Scaffold(
      backgroundColor: Color(0xffe86f16),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text('Details',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),),
          centerTitle: true,
        ),
        body: ListView(children: [
          Stack(children: [
            Container(
              height: MediaQuery.of(context).size.height - 82.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent),
            Positioned(
              top: 75.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45.0),
                    topRight: Radius.circular(45.0),
                  ),
                  color: Colors.white
                ),
              height: MediaQuery.of(context).size.height - 100.0,
              width: MediaQuery.of(context).size.width)),
            Positioned(
              top: 30.0,
              left: (MediaQuery.of(context).size.width / 2) - 100.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white54,
                      child: ClipOval(
                        child: new SizedBox(
                          width: 180.0,
                          height: 180.0,
                          child: (_image!=null)?Image.file(
                            _image,
                            fit: BoxFit.fill,
                          ):Image.network(
                            "https://doffly.mbiodo.com/images/noimage.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 60.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 30.0,
                      ),
                      onPressed: () {
                        getImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 250.0,
              left: 25.0,
              right: 25.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23.0),
                      border: Border.all(
                        color: Warnadasar.menuCar, 
                        style: BorderStyle.solid, 
                        width: 0.80
                      ),
                    ),
                    child: DropdownButton(
                      isExpanded: true,
                      items: dataKategori.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item['description']),
                          value: item['id'].toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelection = newVal;
                          print("searchSource:" + _mySelection);
                        });
                      },
                      value: _mySelection,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  invName,
                  SizedBox(height: 10.0,),
                  harga,
                  SizedBox(height: 10.0,),
                  stok,
                  SizedBox(height: 30,),
                  loginButton,
                  SizedBox(height: 30,),
                  // Row(
                  //   children: <Widget>[
                  //     Expanded(
                  //       child: Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(50),
                  //           color: Colors.blue
                  //         ),
                  //         child: Center(
                  //           child: Text("Facebook", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  //         ),
                  //       ),
                  //     ),
                  //     SizedBox(width: 30,),
                  //     Expanded(
                  //       child: Container(
                  //         height: 50,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(50),
                  //           color: Colors.black
                  //         ),
                  //         child: Center(
                  //           child: Text("Github", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // )
                ],
              )
            )
          ])
        ]));
  }
}