import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/modelInventory.dart';
import '../default/api.dart';
import '../model/modelCategory.dart';
import '../default/constan.dart';

class InventoryCart extends StatefulWidget {
  final VoidCallback readCart;
  InventoryCart(this.readCart);
  @override
  _InventoryCartState createState() => _InventoryCartState();
}

class _InventoryCartState extends State<InventoryCart> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey();
  final oCcy = new NumberFormat("#,##0", "en_US");
  final listCategory = List<CategoryModel>();
  final listInventory = List<InventoryModel>();
  var loadingCategory = false;
  var laodingInventory = false;
  int typeCategory = 0;

  TextEditingController qtyController = TextEditingController();

  _showMsg(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldkey.currentState.showSnackBar(snackBar);
  }

  Future<void> _readCategory() async {
    listCategory.clear();
    setState(() {
      loadingCategory = true;
      listCategory.insert(0, CategoryModel(0, 'Semua'));
    });
    var response = await CallApi().getData('category');
    final data = jsonDecode(response.body);
    print(data);
    if (data['data'] != null) {
      data['data'].forEach((api) {
        final ab = CategoryModel(
          api['id'],
          api['description'],
        );
        listCategory.add(ab);
      });
      setState(() {
        loadingCategory = false;
      });
    }
  }

  Future<void> _readInventory() async {
    listInventory.clear();
    setState(() {
      laodingInventory = true;
    });
    var response = await CallApi().getData('inventory?is_active=true');
    final data = jsonDecode(response.body);
    print(data);
    if (data['data'] != null) {
      if (typeCategory != 0) {
        data['data'].forEach((api) {
          if (api['category']['data']['id'] == typeCategory) {
            final ac = InventoryModel(
              api['id'],
              api['inventory_name'],
              api['price'] + .0,
              api['stock'],
              api['image'],
              api['category']['data']['id'],
              api['category']['data']['description'],
            );
            listInventory.add(ac);
          }
        });
      } else {
        data['data'].forEach((api) {
          final ac = InventoryModel(
            api['id'],
            api['inventory_name'],
            api['price'] + .0,
            api['stock'],
            api['image'],
            api['category']['data']['id'],
            api['category']['data']['description'],
          );
          listInventory.add(ac);
        });
      }
      setState(() {
        laodingInventory = false;
      });
    }
  }

  _addCart(BuildContext context, InventoryModel z) async {
    var data = {
      'inventory_id': z.id,
      'qty': qtyController.text,
    };
    var response = await CallApi().postData(data, 'cart');
    final body = jsonDecode(response.body);
    print(body);
    if (body['data'] != null) {
      setState(() {
        widget.readCart();
      });
      Navigator.pop(context);
      _showMsg(context, '${z.inventoryName} ditambahkan dikasir');
    } else {
      Navigator.pop(context);
      _showMsg(context, '${z.inventoryName} gagal ditambahkan dikasir !');
    }
  }

  dialogDetail(BuildContext context, InventoryModel z) {
    if (z.stock <= 0) {
      return _showMsg(context, '${z.inventoryName} stok telah habis !');
    }
    qtyController.text = '1';
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.network(
                    z.image,
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                  ListTile(
                    title: Text(
                      z.inventoryName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp. ' + oCcy.format(z.price).toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 0, 15.0, 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 140.0,
                      child: TextField(
                        controller: qtyController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(0.0),
                          prefixText: 'Kuantitas :  ',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: 100,
                      child: RaisedButton(
                        onPressed: () {
                          _addCart(context, z);
                        },
                        disabledColor: Colors.grey,
                        color: Warnadasar.menuFood,
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _readCategory();
    _readInventory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Warnadasar.menuFood,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 45.0,
            padding: EdgeInsets.only(top: 10.0),
            child: loadingCategory
                ? Center(child: Text('Loading..'))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: listCategory.length,
                    itemBuilder: (context, i) {
                      var c = listCategory[i];
                      return Container(
                        padding:
                            EdgeInsets.only(left: 3.0, right: 3.0, bottom: 5.0),
                        child: FlatButton(
                          onPressed: () {
                            setState(() {
                              typeCategory = c.id;
                              _readInventory();
                            });
                          },
                          color: typeCategory != c.id
                              ? Colors.white
                              : Warnadasar.menuFood,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            side: BorderSide(color: Colors.red),
                          ),
                          child: Text(
                            c.category,
                            style: TextStyle(
                              color: typeCategory != c.id
                                  ? Warnadasar.menuFood
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            child: laodingInventory
                ? Center(child: CircularProgressIndicator())
                : OrientationBuilder(
                    builder: (context, oriented) {
                      return listInventory.length == 0
                          ? Center(
                              child: Text('Item tidak ada',
                                  style: TextStyle(color: Colors.grey)),
                            )
                          : GridView.builder(
                              padding: EdgeInsets.only(top: 4.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    oriented == Orientation.portrait ? 2 : 4,
                              ),
                              itemCount: listInventory.length,
                              itemBuilder: (context, i) {
                                final z = listInventory[i];
                                return InkWell(
                                  onTap: () {
                                    dialogDetail(context, z);
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Expanded(
                                          child: Stack(
                                            children: <Widget>[
                                              ColorFiltered(
                                                colorFilter: z.stock > 0
                                                    ? ColorFilter.mode(
                                                        Colors.transparent,
                                                        BlendMode.multiply,
                                                      )
                                                    : ColorFilter.mode(
                                                        Colors.grey,
                                                        BlendMode.saturation,
                                                      ),
                                                child: Image.network(
                                                  z.image,
                                                  width: 500.0,
                                                  height: 500.0,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Center(
                                                child: Opacity(
                                                  opacity:
                                                      z.stock > 0 ? 0.0 : 0.75,
                                                  child: Container(
                                                    color: Colors.white,
                                                    padding:
                                                        EdgeInsets.all(10.0),
                                                    child: Text('Stok Habis'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0, left: 10.0),
                                          child: Text(
                                            z.inventoryName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 3.0, left: 10.0),
                                          child: Text(
                                            'Rp. ' +
                                                oCcy.format(z.price).toString(),
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 4.0,
                                              left: 10.0,
                                              bottom: 5.0),
                                          child: Text(
                                            'Sisa stok : ' + z.stock.toString(),
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10.0),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
