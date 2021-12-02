import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/Model/Sales.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() {
    return _SalesScreenState();
  }
}

class _SalesScreenState extends State<SalesScreen> {
  List<charts.Series<Sales, String>> _seriesBarData = [];
  List<Sales>? myData;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _generateData(myData) {
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => sales.saleYear.toString(), //X軸
        measureFn: (Sales sales, _) => sales.saleVal, //Y軸
        colorFn: (Sales sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'Sales',
        data: myData,
        labelAccessorFn: (Sales row, _) => "${row.saleYear}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('sales').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              /*Sales型のリストに変換*/
              List<Sales> myData = snapshot.data!.docs
                  .map((documentSnapshot) => Sales.fromMap(
                      documentSnapshot.data() as Map<String, dynamic>))
                  .toList();
              _generateData(myData);
              return Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Sales by Year',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: charts.BarChart(
                            _seriesBarData,
                            // animate: true,
                            // animationDuration: Duration(seconds: 5),
                            behaviors: [
                              new charts.DatumLegend(
                                entryTextStyle: charts.TextStyleSpec(
                                    //color: charts.MaterialPalette.purple.shadeDefault,
                                    fontFamily: 'Georgia',
                                    fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
