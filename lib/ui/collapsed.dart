import 'package:flutter/material.dart';
import 'package:taxi_app_bloc/blocs/cars_bloc.dart';
import 'package:taxi_app_bloc/blocs/poilist_bloc.dart';
import 'package:taxi_app_bloc/models/poilist_model.dart';

import '../const.dart';
import '../models/cars_model.dart';

class Collapsed extends StatefulWidget {
  final Cars cars;

  Collapsed({Key key, this.cars}) : super(key: key);

  @override
  _CollapsedState createState() => _CollapsedState();
}

class _CollapsedState extends State<Collapsed> {
  Cars cars;
  bool isLoaded;

  @override
  Widget build(BuildContext context) {
    text = StreamBuilder(
      stream: carsBloc.filterCars,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          cars = snapshot.data;
          return Text(
            'There`s ${cars.poiList.length} cars available',
            style: TextStyle(fontSize: 16),
          );
        }
        return Text(
          'There`s ${cars.poiList.length} cars available',
          style: TextStyle(fontSize: 16),
        );
      },
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: loadedData(),
      ),
    );
  }

  Widget loadedData() {
    return Container(
      child: StreamBuilder(
        stream: poiListBloc.selectPoiList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.id > 0)
              return selected(snapshot.data);
            else
              return text;
          } else if (snapshot.hasError) {
            return Text(
              'error ${snapshot.error}',
              style: TextStyle(fontSize: 16),
            );
          } else
            return isLoaded ? text : CircularProgressIndicator();
        },
      ),
    );
  }

  Widget text;

  Widget selected(PoiList poiList) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              child: IconButton(
                  onPressed: () {
                    poiListBloc.removePoList(poiList);
                    poiListBloc.getPoiList(new PoiList(id: 0));
                  },
                  icon: Icon(Icons.cancel)),
              right: 0.0,
            ),
            Row(
              children: <Widget>[
                Image(
                    image: AssetImage(poiList.fleetType == 'POOLING'
                        ? poolImagePath
                        : taxiImagePath)),
                Text(
                  '${poiList.id} is selected',
                  style: TextStyle(fontSize: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    isLoaded = false;
    cars = widget.cars;
    if (cars != null && cars.poiList.length > 0) isLoaded = true;
    super.initState();
  }
}
