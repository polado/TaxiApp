import 'package:flutter/material.dart';
import 'package:taxi_app_bloc/blocs/cars_bloc.dart';
import 'package:taxi_app_bloc/blocs/poilist_bloc.dart';
import 'package:taxi_app_bloc/const.dart';

import '../models/cars_model.dart';
import 'car_item_widget.dart';

class Panel extends StatefulWidget {
  final Cars cars;

  Panel({Key key, this.cars}) : super(key: key);

  @override
  _PanelState createState() => _PanelState();
}

class _PanelState extends State<Panel> {
  Cars cars;
  int _radioValue = -1;
  bool isLoaded;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: isLoaded ? buildList() : CircularProgressIndicator(),
      ),
    );
  }

  Widget buildList() {
    Widget filter = Padding(
      padding: EdgeInsets.all(8),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          Positioned(
              right: 0.0,
              child: Row(
                children: <Widget>[
                  new Radio(
                    value: -1,
                    groupValue: _radioValue,
                    onChanged: onRadioValueChange,
                  ),
                  new Text(
                    'All',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: onRadioValueChange,
                  ),
                  new Text(
                    'Taxi',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  new Radio(

                    value: 1,
                    groupValue: _radioValue,
                    onChanged: onRadioValueChange,
                  ),
                  new Text(
                    'Pooling',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              )),
          Text(
            'Filter: ',
            style: new TextStyle(
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );

    if (cars != null || cars.poiList.length > 0)
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(flex: 1, child: filter),
          Expanded(
              flex: 3,
              child: StreamBuilder(
                  stream: carsBloc.filterCars,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      cars = snapshot.data;
                      return ListView.builder(
                        itemBuilder: (context, int index) {
                          return CarWidget(poiList: cars.poiList[index]);
                        },
                        itemCount: cars.poiList.length,
                        scrollDirection: Axis.horizontal,
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (context, int index) {
                        return CarWidget(poiList: cars.poiList[index]);
                      },
                      itemCount: cars.poiList.length,
                      scrollDirection: Axis.horizontal,
                    );
                  })),
        ],
      );
    else
      return Text('No Data Found!');
  }

  @override
  void initState() {
    isLoaded = false;
    cars = widget.cars;
    if (cars != null && cars.poiList.length > 0) isLoaded = true;
    super.initState();
  }

  void onRadioValueChange(int val) {
    setState(() {
      _radioValue = val;
      if (val == 0)
        carsBloc.getFilteredCars(taxiText);
      else if (val == 1)
        carsBloc.getFilteredCars(poolText);
      else
        carsBloc.getFilteredCars('none');
      poiListBloc.refreshThePoiList();
    });
  }
}
