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
import 'itemsList.dart';

class ItemsFormEdit extends StatefulWidget {
  final String idItems;
  final String nameItems;
  final String priceItems;
  final String stokItems;
  final String kategoriItems;
  final String imageItems;
  ItemsFormEdit(this.idItems, this.nameItems, this.priceItems, this.stokItems, this.kategoriItems, this.imageItems);
  // ItemsFormEdit(this.index,this.id);
  
  // final String index;
  // final String id;
  @override
  _ItemsFormEditState createState() => _ItemsFormEditState(idItems, nameItems, priceItems, stokItems, kategoriItems, imageItems);
}

class _ItemsFormEditState extends State<ItemsFormEdit> {
  final String idItems;
  final String nameItems;
  final String priceItems;
  final String stokItems;
  final String kategoriItems;
  final String imageItems;
  _ItemsFormEditState(this.idItems, this.nameItems, this.priceItems, this.stokItems, this.kategoriItems, this.imageItems);
  var selectedCard = 'WEIGHT';
  String _mySelection;
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

  Future updtaeInv(int id) async{
    setState(() {
    });
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      var request = await CallApi().postDataFile('inventory/edit/${id}');
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

  void _deleteData(int id) async {
    print(id);
    // String active = false;
    // Store all data with Param Name.
    var dataInput = {'is_active':false};
  
    // print(data);
    // Starting Web API Call.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var response = await http.put(BaseUrl.url+'inventory/is_active/${id}', headers: { 'Accept':'application/json','Content-Type':'application/json','Authorization': 'Bearer ${stringValue}'}, body: json.encode(dataInput));
 
    final data = jsonDecode(response.body);
    if (data['data']['is_active'] == false) {
      setState(() {
        // Navigator.pop(context);
        Navigator.pop(context, 'refresh' );
      });
    } else {
      print(data);
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
    txtName.text = nameItems;
    txtStok.text = stokItems;
    txtPrice.text = priceItems;
    _mySelection=kategoriItems;
    print(kategoriItems);
    
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
                            imageItems,
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
                  // loginButton,
                  // SizedBox(height: 30,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            updtaeInv(int.parse(idItems));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue
                            ),
                            child: Center(
                              child: Text("Update", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 30,),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _deleteData(int.parse(idItems));
                          }, 
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Warnadasar.menuFood
                            ),
                            child: Center(
                              child: Text("Delete", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )
            )
          ])
        ]));
  }
}