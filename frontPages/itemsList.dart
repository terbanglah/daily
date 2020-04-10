import 'package:flutter/material.dart';
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



// class Itemslist extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.amber,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: ShowItemList(),
//     );
//   }
// }
class ShowItemList extends StatefulWidget {
  @override
  _ShowItemListState createState() => _ShowItemListState();
}

class _ShowItemListState extends State<ShowItemList> {
  String _mySelection;
  String items;
  final txtName = TextEditingController();
  final txtPrice = TextEditingController();
  final txtStok = TextEditingController();
  File _imageFile;

  Future<File> file;
  String status = '';
  String base64Image;

  List data; //DEFINE VARIABLE data DENGAN TYPE List AGAR DAPAT MENAMPUNG COLLECTION / ARRAY

  Future<String> getData() async {
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
    });
    return 'success!';
  }
  // _showMsg(msg) {
  //   final snackBar = SnackBar(
  //     content: Text(msg),
  //     action: SnackBarAction(
  //       label: 'Close',
  //       onPressed: () {
  //         // Some code to undo the change!
  //       },
  //     ),
  //   );
  //   Scaffold.of(context).showSnackBar(snackBar);
  // }

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

  void initState() {
    super.initState();
    this.getData(); //PANGGIL FUNGSI YANG TELAH DIBUAT SEBELUMNYA
    this.getCategoryData();
    _mySelection=items;
  } 

  

  Future updtaeInv(int id) async{
    FocusScope.of(context).requestFocus(FocusNode());
    try {
      var request = await CallApi().postDataFile('inventory/edit/${id}');
      request.headers.addAll(await CallApi().setHeader());
      request.fields['category_id'] = _mySelection;
      request.fields['inventory_name'] = txtName.text;
      request.fields['price'] = txtPrice.text;
      request.fields['stock'] = txtStok.text;
      if (_imageFile != null) {
        var stream =
            http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
        var length = await _imageFile.length();
        request.files.add(http.MultipartFile('image', stream, length,
            filename: path.basename(_imageFile.path)));
      }
      print(path.basename(_imageFile.path));
      var response = await request.send();
      print(response.statusCode);
      if (response.statusCode > 2) { //response status 201 (created)
        var body = json.decode(await response.stream.bytesToString());
        if (body['data'] != null) {
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('user', json.encode(body['data']));
          print('File Uploaded');
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
    // // Showing CircularProgressIndicator.
    // setState(() {
    // });
    // String name = txtName.text;
    // String price = txtPrice.text;
    // // Store all data with Param Name.
    // var data = {'category_id':_mySelection,'inventory_name': name, 'price'	: price};
  
    // // print(data);
    // // Starting Web API Call.
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String stringValue = prefs.getString('Token');
    // var response = await http.post(BaseUrl.updateItemList+'${id}', headers: { 'Accept':'application/json','Content-Type':'application/json','Authorization': 'Bearer ${stringValue}'}, body: json.encode(data));
 
    // // Getting Server response into variable.
    // var message = jsonDecode(response.body);
    // var errorMessage;
    // print(message);
    // if(message['data']['inventory_name'] == name){
    //    Navigator.of(context).pop();
    // }
    // else {
    //   errorMessage = 'Simpan gagal';
    //   showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: new Text(errorMessage),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: new Text("OK"),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   }
    //   );
    // }
  }

  _chooseGallery() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      _imageFile = image;
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          _imageFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  _chooseCamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      _imageFile = image;
    });
  }

  Future<String> checkImageProfile() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = json.decode(localStorage.getString('user'));

    return user['avatar'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black12,
              spreadRadius: 5,
              blurRadius: 2
            )]
          ),
          width: MediaQuery.of(context).size.width,
          height: 90,
          child: Container(
            decoration: BoxDecoration(
              color: Warnadasar.menuCar,
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
            ),
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              margin: EdgeInsets.fromLTRB(0,20, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.navigate_before,size: 28,color: Colors.transparent,),
                  Image.asset('1.png', width: 70.0),
                  // Text("Items",style: TextStyle(fontSize: 20,color: Warnadasar.white, fontWeight: FontWeight.bold),),
                  Icon(Icons.navigate_before,color: Colors.transparent,),
                ],
              ),
            ),
          ),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Warnadasar.menuOther,
      //   title: Text(
      //     'Kasir',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   iconTheme: IconThemeData(color: Colors.white),
        
      // ),
      backgroundColor: Colors.blueGrey.shade100,
      
      body: Container(
          
          margin: EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0, bottom: 10.0), //SET MARGIN DARI CONTAINER
          // padding: EdgeInsets.only(bottom: 50.0),
          child: ListView.builder( //MEMBUAT LISTVIEW
            padding: EdgeInsets.only(bottom: 60.0),
            itemCount: data == null ? 0:data.length, //KETIKA DATANYA KOSONG KITA ISI DENGAN 0 DAN APABILA ADA MAKA KITA COUNT JUMLAH DATA YANG ADA
            itemBuilder: (BuildContext context, int index) { 
              return Container(
                child: Card(
                  // color: Color(0xffc8e6c9),
                  // color: Color(Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, children: <Widget>[
                    //ListTile MENGELOMPOKKAN WIDGET MENJADI BEBERAPA BAGIAN
                    ListTile(
                      //leading TAMPIL PADA SEBELAH KIRI
                      // DIMANA VALUE DARI leading ADALAH WIDGET TEXT
                      // YANG BERISI NOMOR SURAH
                      // leading: Text(data[index]['id'].toString(), style: TextStyle(fontSize: 20.0),),
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
                      //title TAMPIL DITENGAH SETELAH leading
                      // VALUENYA ADALAH WIDGET TEXT
                      // YANG BERISI NAMA SURAH
                      
                      title: Text(data[index]['inventory_name'], style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                      // //subtitle TAMPIL TEPAT DIBAWAH title
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
                    ),
                    //TERAKHIR, MEMBUAT BUTTON
                    ButtonTheme.bar(
                      child: ButtonBar(
                        buttonPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                        children: <Widget>[
                          // BUTTON PERTAMA 
                          Text(data[index]['publish'], style: TextStyle(fontSize: 12.0),textAlign: TextAlign.end,),
                          new SizedBox(width: 10.0,),
                          new SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: IconButton(
                            //DENGAN TEXT DENGARKAN
                              icon: new Icon(
                                Icons.delete,
                                size: 20.0,
                                color: Warnadasar.menuOther,
                              ),
                              // alignment: Alignment.centerLeft,
                              padding: new EdgeInsets.only(right: 10.0),
                              onPressed: () {  },
                            ),
                          ),
                          // //BUTTON KEDUA
                          new SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: IconButton(
                            //DENGAN TEXT DENGARKAN
                              icon: new Icon(
                                Icons.create,
                                size: 20.0,
                                color: Warnadasar.menuOther,
                              ),
                              // alignment: Alignment.centerLeft,
                              padding: new EdgeInsets.only(right: 10.0),
                              onPressed: () { 
                                // showSimpleCustomDialog(context);
                                // this.getCategoryData();
                                _onPressEdit(index, data[index]['id']);
                              },
                            ),
                          )
                          
                        ],
                      ),
                    ),
                  
                  ],),
                )
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: (){
          _onPressAdd();
        },
        tooltip: 'Increment',
        backgroundColor: Warnadasar.menuOther,
        child: Icon(Icons.add),
      ),
    );
  }

  
  void _onPressAdd(){
    final invName = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'nama',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Warnadasar.defaultColor))
      ),
      controller: txtName,
    );
    final harga = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'Harga',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Warnadasar.defaultColor))
      ),
      controller: txtPrice,
    );
    txtName.text = "";
    txtPrice.text = "";
    //print(_mySelection);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Add Inventory"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 250.0,
                width: 300.0,
                child: Column(
                  children: <Widget>[
                    invName,
                    SizedBox(height: 10.0,),
                    harga,
                    SizedBox(height: 20.0,),
                    DropdownButton(
                      // : txtPhoneCompany,
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
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.blue,
              onPressed: () {
                simpanInv();
                Navigator.of(context).pop();
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
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'nama',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Warnadasar.defaultColor))
      ),
      controller: txtName,
    );
    final harga = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'Harga',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Warnadasar.defaultColor))
      ),
      controller: txtPrice,
    );
    final stok = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
        // hintText: 'Email',
        // contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        labelText: 'Stok',
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.bold,
          color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Warnadasar.defaultColor))
      ),
      controller: txtStok,
    );
    txtName.text = data[index]['inventory_name'];
    txtStok.text = data[index]['stock'].toString();
    txtPrice.text = data[index]['price'].toString();
    _mySelection=data[index]['category']['data']['id'].toString();
    //print(_mySelection);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Edit Inventory"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 350.0,
                width: 300.0,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 70.0,
                      child: InkWell(
                        onTap: _chooseGallery,
                        child: FutureBuilder(
                          future: checkImageProfile(),
                          builder:
                              (BuildContext context, AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              if (_imageFile == null) {
                                return CircleAvatar(
                                  radius: 75.0,
                                  backgroundImage: NetworkImage(snapshot.data),
                                  backgroundColor: Colors.transparent,
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 75.0,
                                  backgroundImage: FileImage(_imageFile),
                                  backgroundColor: Colors.transparent,
                                );
                              }
                            } else {
                              return Text('No Image');
                            }
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          invName,
                          SizedBox(height: 10.0,),

                          harga,
                          SizedBox(height: 20.0,),
                          stok,
                          SizedBox(height: 20.0,),
                          DropdownButton(
                            // : txtPhoneCompany,
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
                borderRadius: BorderRadius.circular(24),
              ),
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
                updtaeInv(id);
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

  Future simpanInv() async{
    // Showing CircularProgressIndicator.
    setState(() {
    });
 
    // Getting value from Controller
    String name = txtName.text;
    String price = txtPrice.text;
    // Store all data with Param Name.
    var data = {'category_id':_mySelection,'inventory_name': name, 'price'	: price};
  
    // print(data);
    // Starting Web API Call.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('Token');
    var response = await http.post(BaseUrl.simpanItemList, headers: { 'Accept':'application/json','Content-Type':'application/json','Authorization': 'Bearer ${stringValue}'}, body: json.encode(data));
 
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    var errorMessage;
    // print(message);
    if(message['data']['inventory_name'] == name){
       getData();
      //  Navigator.of(context).pop();
    }
    else {
      errorMessage = 'Simpan gagal';
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
  }

}