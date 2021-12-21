// import 'package:flutter/material.dart';
//
// class TaskScreen extends StatefulWidget {
//   const TaskScreen({Key? key}) : super(key: key);
//
//   @override
//   _TaskScreenState createState() => _TaskScreenState();
// }
//
// class _TaskScreenState extends State<TaskScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text('TaskScreen'),
//       ),
//     );
//   }
// }

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_chart_json/task.dart';
import 'package:pie_chart/Model/Task.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() {
    return _TaskScreenState();
  }
}

class _TaskScreenState extends State<TaskScreen> {
  List<charts.Series<Task, String>> _seriesPieData = [];
  List<Task>? myData;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  _generateData(myData) {
    //_seriesPieData = List<charts.Series<Task, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.taskDetails,
        measureFn: (Task task, _) => task.taskVal,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(task.colorVal))),
        id: 'tasks',
        data: myData,
        labelAccessorFn: (Task row, _) => "${row.taskVal}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('task').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Task> myData = snapshot.data!.docs
                .map((documentSnapshot) => Task.fromMap(
                    documentSnapshot.data() as Map<String, dynamic>))
                .toList();
            _generateData(myData);
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Time spent on daily tasks',
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Expanded(
                        child: charts.PieChart(
                          _seriesPieData,

                          // animate: true,
                          // animationDuration: Duration(seconds: 5),
                          behaviors: [
                            new charts.DatumLegend(
                              outsideJustification:
                                  charts.OutsideJustification.endDrawArea,
                              horizontalFirst: false,
                              desiredMaxRows: 2,
                              cellPadding: EdgeInsets.only(
                                right: 4.0,
                                bottom: 4.0,
                                top: 4.0,
                              ),
                              entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 18,
                              ),
                            )
                          ],
                          // defaultRenderer: new charts.ArcRendererConfig(
                          //   arcWidth: 100,
                          //   arcRendererDecorators: [
                          //     new charts.ArcLabelDecorator(
                          //         labelPosition: charts.ArcLabelPosition.inside)
                          //   ],
                          // ),
                          defaultRenderer:
                              charts.ArcRendererConfig(arcWidth: 60),
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
    );
  }

  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _firestore.collection('task').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(child: CircularProgressIndicator());
  //       } else {
  //         List<Task> task = snapshot.data!.docs
  //             .map((documentSnapshot) =>
  //                 Task.fromMap(documentSnapshot.data() as Map<String, dynamic>))
  //             .toList();
  //         return _buildChart(context, task);
  //       }
  //     },
  //   );
  // }

  // Widget _buildChart(BuildContext context, List<Task> taskData) {
  //   myData = taskData;
  //   _generateData(myData);
  //   return Padding(
  //     padding: EdgeInsets.all(8.0),
  //     child: Container(
  //       child: Center(
  //         child: Column(
  //           children: <Widget>[
  //             Text(
  //               'Time spent on daily tasks',
  //               style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  //             ),
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             Expanded(
  //               child: charts.PieChart(
  //                 _seriesPieData,
  //
  //                 // animate: true,
  //                 // animationDuration: Duration(seconds: 5),
  //                 behaviors: [
  //                   new charts.DatumLegend(
  //                     outsideJustification:
  //                         charts.OutsideJustification.endDrawArea,
  //                     horizontalFirst: false,
  //                     desiredMaxRows: 2,
  //                     cellPadding: new EdgeInsets.only(
  //                         right: 4.0, bottom: 4.0, top: 4.0),
  //                     entryTextStyle: charts.TextStyleSpec(
  //                         color: charts.MaterialPalette.purple.shadeDefault,
  //                         fontFamily: 'Georgia',
  //                         fontSize: 18),
  //                   )
  //                 ],
  //                 // defaultRenderer: new charts.ArcRendererConfig(
  //                 //   arcWidth: 100,
  //                 //   arcRendererDecorators: [
  //                 //     new charts.ArcLabelDecorator(
  //                 //         labelPosition: charts.ArcLabelPosition.inside)
  //                 //   ],
  //                 // ),
  //                 defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
