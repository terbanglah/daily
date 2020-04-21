import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/modelSale.dart';
import '../default/api.dart';
import '../default/constan.dart';

class SaleDetail extends StatefulWidget {
  final int saleId;
  SaleDetail(this.saleId);
  @override
  _SaleDetailState createState() => _SaleDetailState();
}

class _SaleDetailState extends State<SaleDetail> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  final listdetail = List<SaleDetailModel>();
  var loading = false;
  var sale = SaleModel(null,null, null, null, null, null, null, null, null, null);

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    listdetail.clear();
    var response = await CallApi().getData('sale/${widget.saleId}');
    final data = jsonDecode(response.body);
    print('Sale : $data');
    if (data['data'] != null) {
      data['data']['sale_details']['data'].forEach((api) {
        final ac = SaleDetailModel(
          data['data']['id'],
          api['id'],
          api['inventory_id'],
          api['inventory_name'],
          api['price'] + .0,
          api['qty'],
          api['amount'] + .0,
          api['image'],
          api['category']['description'],
        );
        listdetail.add(ac);
      });
      sale = SaleModel(
        false,
        data['data']['id'],
        data['data']['sale_no'],
        data['data']['type_payment']['payment_id'],
        data['data']['type_payment']['description'],
        data['data']['amount'] + .0,
        data['data']['pay'] + .0,
        data['data']['refund'] + .0,
        data['data']['created_by'],
        listdetail,
      );
      setState(() {
        loading = false;
      });
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
      body: Container(
        padding: EdgeInsets.only(top: 40.0, right: 5.0, left: 5.0),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Warnadasar.menuFood,
                    elevation: 10,
                    child: Container(
                      height: 175.0,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.beenhere, size: 50),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  'Pembayaran : ${sale.payment}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Total Harga : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  ' Rp. ${oCcy.format(sale.amount)}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Dibayar : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  ' Rp. ${oCcy.format(sale.pay)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Kembali : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  ' Rp. ${oCcy.format(sale.refund)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: <Widget>[
                                Text(
                                  '#${sale.saleNo}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // SizedBox(
                                //   height: 5.0,
                                // ),
                                // Text(
                                //   'kasir :',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //   ),
                                // ),
                                // Text(
                                //   sale.createBy,
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 5.0),
                      itemCount: sale.details.length,
                      itemBuilder: (context, i) {
                        var x = sale.details[i];
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
                  )
                ],
              ),
      ),
      bottomNavigationBar: Container(
        child: MaterialButton(
          height: 75.0,
          color: Warnadasar.menuFood,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Selesai',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }
}
