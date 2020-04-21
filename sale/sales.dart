import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../default/api.dart';
import '../model/modelSale.dart';
import '../default/constan.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  var loading = false;
  final listsale = List<SaleModel>();
  final listdetail = List<SaleDetailModel>();
  double saleamount = 0;
  DateTime selectedDate = DateTime.now();

  TextEditingController monthController = TextEditingController();

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    listsale.clear();
    listdetail.clear();
    var response =
        await CallApi().getData('sale?period=${monthController.text}');
    print('sale : ${response.body}');
    final data = jsonDecode(response.body);
    if (data['data'] != null) {
      saleamount = 0;
      data['data'].forEach((a) {
        a['sale_details']['data'].forEach((b) {
          final detail = SaleDetailModel(
            a['id'],
            b['id'],
            b['inventory_id'],
            b['inventory_name'],
            b['price'] + .0,
            b['qty'],
            b['amount'] + .0,
            b['image'],
            b['category']['description'],
          );
          listdetail.add(detail);
        });
        final sale = SaleModel(
          false,
          a['id'],
          a['sale_no'],
          a['type_payment']['payment_id'],
          a['type_payment']['description'],
          a['amount'] + .0,
          a['pay'] + .0,
          a['refund'] + .0,
          a['created_by'],
          listdetail,
        );
        saleamount += a['amount'];
        listsale.add(sale);
      });
      setState(() {
        loading = false;
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showMonthPicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        monthController.text = DateFormat('MM/yyyy').format(picked);
        selectedDate = picked;
        _readData();
      });
  }

  @override
  void initState() {
    monthController.text = DateFormat('MM/yyyy').format(selectedDate);
    _readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Warnadasar.menuShop,
        title: Text(
          'Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: monthController,
                        decoration: new InputDecoration(
                          contentPadding: EdgeInsets.all(13.0),
                          labelText: "Bulan/Tahun",
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.calendar_today),
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                listsale.length == 0
                    ? Center(
                        child: Text(
                          'Penjualan tidak ada',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 4.0, left: 4.0, top: 0.0, bottom: 0.0),
                            child: ListView.builder(
                              itemCount: listsale.length,
                              itemBuilder: (context, i) {
                                var sale = listsale[i];
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ExpansionPanelList(
                                    animationDuration: Duration(seconds: 1),
                                    expansionCallback:
                                        (int index, bool isExpanded) {
                                      setState(() {
                                        sale.isExpanded = !sale.isExpanded;
                                      });
                                    },
                                    children: [
                                      ExpansionPanel(
                                        canTapOnHeader: true,
                                        headerBuilder: (BuildContext context,
                                            bool isExpanded) {
                                          return ListTile(
                                            title: Text(
                                              'No. Penjualan #${sale.saleNo}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0),
                                            ),
                                            subtitle: Text('Rp. ' +
                                                oCcy
                                                    .format(sale.amount)
                                                    .toString()),
                                          );
                                        },
                                        isExpanded: sale.isExpanded,
                                        body: ListView.builder(
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 10.0),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: sale.details.length,
                                          itemBuilder: (context, z) {
                                            var x = sale.details[z];
                                            if (x.saleId == sale.id) {
                                              return ListTile(
                                                leading: CircleAvatar(
                                                  //radius: 25,
                                                  backgroundImage:
                                                      NetworkImage(x.image),
                                                ),
                                                title: Text(x.inventoryName),
                                                subtitle: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Rp. ' +
                                                          oCcy
                                                              .format(x.price)
                                                              .toString(),
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
                                                  'Rp. ' +
                                                      oCcy
                                                          .format(x.amount)
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ],
            ),
      bottomNavigationBar: Container(
        color: Warnadasar.white,
        height: 75.0,
        child: ListTile(
          title: Text(
            'Total Penjualan',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            'Rp. ' + oCcy.format(saleamount).toString(),
            style: TextStyle(
              color: Warnadasar.menuShop,
            ),
          ),
        ),
      ),
    );
  }
}
