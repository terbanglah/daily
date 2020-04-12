import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learn_project/cashier/inventorycart.dart';
import '../default/constan.dart';
import '../model/constants.dart';
import '../default/api.dart';
import '../model/modelCart.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();
  var loading = false;
  double amount = 0;
  final list = List<CartModel>();

  TextEditingController qtyController = TextEditingController();

  Future<void> _readData() async {
    list.clear();
    amount = 0;
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData('cart');
    final data = jsonDecode(response.body);
    //print(data);
    if (data['data'] != null) {
      data['data'].forEach((api) {
        final ab = CartModel(
          api['id'],
          api['inventory']['id'],
          api['inventory']['inventory_name'],
          api['inventory']['price'] + .0,
          api['qty'],
          api['inventory']['image'],
        );
        amount += api['inventory']['price'] + .0 * api['qty'];
        list.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(16.0),
            shrinkWrap: true,
            children: <Widget>[
              Text(id != 'all'
                  ? 'Anda yakin ingin menghapus produk ini ?'
                  : 'Anda yakin menghapus semua produk ?'),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 80.0,
                    height: 40.0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.shade400,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'No',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 80.0,
                    height: 40.0,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey.shade400,
                        onTap: () {
                          _deleteData(id);
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            'Yes',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  dialogUpdate(CartModel x) {
    qtyController.text = x.qty.toString();
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
                  ClipRRect(
                    child: Image.network(
                      x.image,
                      height: 200,
                      fit: BoxFit.fill,
                    ),
                  ),
                  ListTile(
                    title: Text(
                      x.inventoryName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Rp. ' + oCcy.format(x.price).toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
              Container(
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
                          _updateData(x);
                          Navigator.pop(context);
                        },
                        disabledColor: Colors.grey,
                        color: Warnadasar.menuFood,
                        child: Text(
                          'Ubah',
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

  _updateData(CartModel x) async {
    var data = {
      'qty': qtyController.text,
    };
    var response = await CallApi().putData(data, 'cart/${x.id}');
    //print(response.body);
    final body = jsonDecode(response.body);
    if (body['data'] != null) {
      setState(() {
        _readData();
      });
    } else {
      print(data);
    }
  }

  _deleteData(String id) async {
    print(id);
    var response =
        await CallApi().deleteData(id != 'all' ? 'cart/$id' : 'cart');
    final data = jsonDecode(response.body);
    if (data['message'] == 'deleted') {
      setState(() {
        // Navigator.pop(context);
        _readData();
      });
    } else {
      print(data);
    }
  }

  void choiceAction(String choice) {
    if (choice == Constants.delete_all) {
      dialogDelete('all');
    }
  }

  @override
  void initState() {
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Warnadasar.menuFood,
        title: Text(
          'Kasir',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: RefreshIndicator(
        key: _refresh,
        onRefresh: _readData,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : list.length == 0
                ? Center(
                    child: Text(
                      'Item kasir tidak ada',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return ListTile(
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(x.image),
                        ),
                        title: Text(x.inventoryName),
                        subtitle: Row(
                          children: <Widget>[
                            Text(
                              'Rp. ' + oCcy.format(x.price).toString(),
                              style: TextStyle(color: Colors.red),
                            ),
                            SizedBox(width: 10.0),
                            Text('x'),
                            SizedBox(width: 10.0),
                            Text(
                              x.qty.toString(),
                            ),
                          ],
                        ),
                        trailing: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                dialogDelete(x.id.toString());
                              },
                              child: Icon(Icons.close),
                            ),
                          ),
                        ),
                        onTap: () {
                          dialogUpdate(x);
                        },
                      );
                    },
                  ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text('Total'),
                subtitle: Text('Rp. ' + oCcy.format(amount).toString()),
              ),
            ),
            Expanded(
              child: MaterialButton(
                height: 75.0,
                color: Warnadasar.menuFood,
                onPressed: () {},
                child: Text(
                  'Bayar',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InventoryCart(_readData)));
        },
        backgroundColor: Warnadasar.menuFood,
        tooltip: 'Add',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
