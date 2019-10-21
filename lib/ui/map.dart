import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:taxi_app_bloc/blocs/cars_bloc.dart';
import 'package:taxi_app_bloc/models/cars_model.dart';

import 'collapsed.dart';
import 'google_map.dart';
import 'panel.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  void initState() {
    carsBloc.getCars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Taxi App"),
      ),
      body: Container(
        child: StreamBuilder(
            stream: carsBloc.allCars,
            builder: (context, AsyncSnapshot<Cars> snapshot) {
              if (snapshot.hasData) {
                return SlidingUpPanel(
                    maxHeight: 200,
                    minHeight: 70,
                    defaultPanelState: PanelState.OPEN,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                    margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                    body: GoogleMaps(cars: snapshot.data),
                    panel: Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 0),
                            child: Panel(
                              cars: snapshot.data,
                            ))),
                    collapsed: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.0),
                              topRight: Radius.circular(24.0)),
                        ),
                        child: Collapsed(
                          cars: snapshot.data,
                        )));
              } else if (snapshot.hasError) {
                return Center(child: Text('error ${snapshot.error}'));
              } else
                return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
