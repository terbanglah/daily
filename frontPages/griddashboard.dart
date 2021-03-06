
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cashier/cart.dart';
import '../sale/sales.dart';
import 'itemsList.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = new Items(
      title: "Kasir",
      subtitle: "March, Wednesday",
      event: "3 Events",
      img: "assets/cashier.png",
      color:0xffd32f2f,
  );

  Items item2 = new Items(
    title: "Penjualan",
    subtitle: "Bocali, Apple",
    event: "4 Items",
    img: "assets/penjualan.png",
    color:0xff14639e,
  );
  // Items item3 = new Items(
  //   title: "Inventori",
  //   subtitle: "Lucy Mao going to Office",
  //   event: "",
  //   img: "assets/list.png",
  //   color:0xff2da5d9,
  // );
  Items item4 = new Items(
    title: "Analisa",
    subtitle: "Rose favirited your Post",
    event: "",
    img: "assets/analisa.png",
    color:0xff0b945e,
  );
  Items item5 = new Items(
    title: "Item",
    subtitle: "Homework, Design",
    event: "4 Items",
    img: "assets/items.png",
    color:0xffe86f16,
  );
  // Items item6 = new Items(
  //   title: "Settings",
  //   subtitle: "",
  //   event: "2 Items",
  //   img: "assets/setting.png",
  // );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item4, item5];
    // var color = 0xff453658;
    // var color = Colors.blueGrey[700];
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: (){
                if(data.title=="Kasir"){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => CartPage())
                  );
                }else if(data.title=="Penjualan"){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => SalePage())
                  );
                }else if(data.title=="Inventori"){
                  
                }else if(data.title=="Analisa"){
                  
                }else if(data.title=="Item"){
                  Navigator.push(context, 
                    MaterialPageRoute(builder: (context) => ShowItemList()),
                  );
                }
              },
              child: new Container(
                decoration: BoxDecoration(
                  color: Color(data.color), borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 62,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.event,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  var color;
  Items({this.title, this.subtitle, this.event, this.img, this.color});
}
