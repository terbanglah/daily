import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../default/api.dart';
import '../model/modelSale.dart';
import '../default/constan.dart';

class SaleDetailpage extends StatefulWidget {
  final int saleId;
  SaleDetailpage(this.saleId);
  @override
  _SaleDetailpageState createState() => _SaleDetailpageState();
}

class _SaleDetailpageState extends State<SaleDetailpage> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  var loading = false;
  final listdetail = List<SaleDetailModel>();
  double saleamount = 0;

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    var response = await CallApi().getData('sale/${widget.saleId.toString()}');
    final data = jsonDecode(response.body);
    print('Sale Detail : $data');
    if (data['data'] != null) {
      saleamount = 0;
      data['data']['sale_details']['data'].forEach((api) {
        final ab = SaleDetailModel(
          api['id'],
          api['inventory_id'],
          api['inventory_name'],
          api['price'] + .0,
          api['qty'],
          api['amount'] + .0,
          api['image'],
          api['category']['description'],
        );
        saleamount += api['amount'];
        listdetail.add(ab);
      });
    }
    setState(() {
      loading = false;
    });
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
        backgroundColor: Warnadasar.menuShop,
        title: Text(
          'Penjualan #${widget.saleId}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: listdetail.length,
              itemBuilder: (context, i) {
                var x = listdetail[i];
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
                      ),
                      SizedBox(width: 10.0),
                      Text('x'),
                      SizedBox(width: 10.0),
                      Text(
                        x.qty.toString(),
                      ),
                    ],
                  ),
                  trailing: Text(
                    'Rp. ' + oCcy.format(x.amount).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Warnadasar.menuShop,
        height: 75.0,
        child: ListTile(
          title: Text(
            'Total Pembelian',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            'Rp. ' + oCcy.format(saleamount).toString(),
            style: TextStyle(
              color: Warnadasar.white,
            ),
          ),
        ),
      ),
    );
  }
}
