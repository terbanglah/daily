import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          double.parse(api['inventory']['price']),
          api['qty'],
          api['inventory']['image'],
        );
        amount += double.parse(api['inventory']['price']) * api['qty'];
        list.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  dialogImage(String image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(image),
        );
      },
    );
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
              Text('Anda yakin ingin menghapus produk ini ?'),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _deleteData(id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        dialogImage(x.image);
                      },
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(x.image),
                      ),
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
                    trailing: InkWell(
                        onTap: () {
                          dialogDelete(x.id.toString());
                        },
                        child: Icon(Icons.close)),
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
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
