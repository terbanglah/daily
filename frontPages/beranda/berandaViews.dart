import 'package:flutter/material.dart';
import '../../sale/sales.dart';
import '../../default/constan.dart';
import '../../loginPages/signIn.dart';
import '../../cashier/cart.dart';
import '../itemsList.dart';

import 'berandaModel.dart';
class BerandaView extends StatefulWidget {
  @override
  _BerandaViewState createState() => _BerandaViewState();
}

class _BerandaViewState extends State<BerandaView> {

  List<YesService> _gojekServiceList = [];

  @override
  void initState() {
    super.initState();

    _gojekServiceList.add(new YesService(
        image: Icons.print,
        color: Warnadasar.menuFood,
        title: "KASIR"));
    _gojekServiceList.add(new YesService(
        image: Icons.monetization_on,
        color: Warnadasar.menuShop,
        title: "PENJUALAN"));
    _gojekServiceList.add(new YesService(
        image: Icons.assignment,
        color: Warnadasar.menuTix,
        title: "INVENTORY"));
    _gojekServiceList.add(new YesService(
        image: Icons.insert_chart,
        color: Warnadasar.menuBluebird,
        title: "ANALISA"));
    _gojekServiceList.add(new YesService(
        image: Icons.list, 
        color: Warnadasar.menuOther, 
        title: "ITEMS"));
    _gojekServiceList.add(new YesService(
        image: Icons.apps, 
        color: Warnadasar.defaultColor, 
        title: "LAINNYA"));
  }
  
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: new Scaffold(
        // appBar: new GojekAppBar(),
        backgroundColor: Colors.grey.shade400,
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(60.0),
        //   child:new AppBarMenu(context),
        //   ),
        // backgroundColor: YesPalette.grey,
        body: new Container(
          child: new ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              new Container(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      // _buildGopayMenu(),
                      // _headerHome(),
                      _buildGojekServicesMenu(),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGojekServicesMenu() {
    return new SizedBox(
      width: double.infinity,
      height: 220.0,
      child: new Container(
        margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: GridView.builder(
          physics: ClampingScrollPhysics(),
          itemCount: 5,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4),
          itemBuilder:(context, position) {
            return _rowService(_gojekServiceList[position]);
          }
        )
      )
    );
  }

  Widget _rowService(YesService gojekService){
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if(gojekService.title== 'KASIR'){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => CartPage())
                );
                // showModalBottomSheet<void>(
                //   context: context,
                //   builder: (context) {
                //     // Center(child: Text('Coba'));
                //     return _buildMenuBottomSheet();
                //   }
                // );
              }
              else if(gojekService.title== 'PENJUALAN'){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => SalePage())
                );
                // Navigator.push(
                //   context,
                //     MaterialPageRoute(builder: (context) => Inventory())
                // );
              }
              else if(gojekService.title== 'ITEMS'){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => Itemslist())
                );
                // Navigator.push(
                //   context,
                //     MaterialPageRoute(builder: (context) => Inventory())
                // );
              }
            },
            child: new Container(
              decoration: new BoxDecoration(
                  border: Border.all(color: gojekService.color, width: 1.0),
                  borderRadius:
                      new BorderRadius.all(new Radius.circular(28.0)),
                  color: gojekService.color
                  ),
              padding: EdgeInsets.all(12.0),
              child: new Icon(
                gojekService.image,
                color: Colors.white,
                size: 32.0,
              ),
            ),
          ),
          new Padding(
            padding: EdgeInsets.only(top: 6.0),
          ),
          new Text(gojekService.title, style: new TextStyle(fontSize: 10.0))
        ],
      ),
    );
  }

}