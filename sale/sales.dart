import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../sale/saledetail.dart';
import '../default/constan.dart';
import '../default/api.dart';
import '../model/modelSale.dart';

class SalePage extends StatefulWidget {
  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final oCcy = new NumberFormat("#,##0", "en_US");
  var loading = false;
  final listsale = List<SaleModel>();
  double saleamount = 0;
  DateTime selectedDate = DateTime.now();

  TextEditingController monthController = TextEditingController();

  Future<void> _readData() async {
    setState(() {
      loading = true;
    });
    listsale.clear();
    var response =
        await CallApi().getData('sale?period=${monthController.text}');
    print('sale : ${response.body}');
    final data = jsonDecode(response.body);
    if (data['data'] != null) {
      saleamount = 0;
      data['data'].forEach((api) {
        final ab = SaleModel(
          false,
          api['id'],
          api['sale_no'],
          api['type_payment']['payment_id'],
          api['type_payment']['description'],
          api['amount'] + .0,
          api['pay'] + .0,
          api['refund'] + .0,
          api['created_by'],
          api['publish'],
          null,
        );
        saleamount += api['amount'];
        listsale.add(ab);
      });
    }
    setState(() {
      loading = false;
    });
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Warnadasar.menuShop,
        title: Text(
          'Penjualan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          Expanded(
            child: Center(
              child: loading
                  ? Center(child: CircularProgressIndicator())
                  : listsale.length == 0
                      ? Center(
                          child: Text(
                            'Penjualan tidak ada',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: listsale.length,
                          itemBuilder: (context, i) {
                            var sale = listsale[i];
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
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
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15.0),
                                        ),
                                        subtitle: Text('Rp. ' +
                                            oCcy
                                                .format(sale.amount)
                                                .toString()),
                                      );
                                    },
                                    isExpanded: sale.isExpanded,
                                    body: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 15.0, left: 20.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Pembayaran :',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                ' ${sale.payment}',
                                                style: TextStyle(
                                                  color: Warnadasar.menuShop,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Total Pembelian :',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                ' Rp. ${oCcy.format(sale.amount)}',
                                                style: TextStyle(
                                                  color: Warnadasar.menuShop,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Dibayar :',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                ' Rp. ${oCcy.format(sale.pay)}',
                                                style: TextStyle(
                                                  color: Warnadasar.menuShop,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Kembali :',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                ' Rp. ${oCcy.format(sale.refund)}',
                                                style: TextStyle(
                                                  color: Warnadasar.menuShop,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8.0),
                                              Text(
                                                'Kasir : ${sale.createdBy}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Text(
                                                'Waktu Pembelian : ${sale.createdAt}',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 0,
                                          color: Colors.grey,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SaleDetailpage(sale),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 50.0,
                                            child: Center(
                                              child: Text(
                                                "Rincian Penjulan",
                                                style: TextStyle(
                                                  color: Warnadasar.menuShop,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Warnadasar.menuShop,
        height: 75.0,
        child: ListTile(
          title: Text(
            'Total Penjualan',
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
