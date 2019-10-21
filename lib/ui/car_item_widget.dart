import 'package:flutter/material.dart';
import 'package:taxi_app_bloc/blocs/poilist_bloc.dart';
import 'package:taxi_app_bloc/const.dart';

import '../models/poilist_model.dart';

class CarWidget extends StatefulWidget {
  final PoiList poiList;

  CarWidget({this.poiList});

  @override
  _CarWidgetState createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  Image icon = new Image.asset(poolImagePath);

  Color color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: poiListBloc.refreshPoiList,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          setIcon();
          return Container(
            color: color,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  poiListBloc.getPoiList(widget.poiList);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 8)),
                    Expanded(child: icon),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Text(
                      '${widget.poiList.id}',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
          color: color,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                poiListBloc.getPoiList(widget.poiList);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 8)),
                  Expanded(child: icon),
                  Padding(padding: EdgeInsets.only(top: 16)),
                  Text(
                    '${widget.poiList.id}',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  setIcon() {
      icon = new Image.asset(
          widget.poiList.fleetType == poolText ? poolImagePath : taxiImagePath);
  }

  @override
  void initState() {
    setIcon();
    super.initState();
  }
}
