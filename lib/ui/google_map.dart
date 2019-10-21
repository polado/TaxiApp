import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taxi_app_bloc/blocs/cars_bloc.dart';
import 'package:taxi_app_bloc/blocs/poilist_bloc.dart';
import 'package:taxi_app_bloc/models/poilist_model.dart';

import '../const.dart';
import '../models/cars_model.dart';

class GoogleMaps extends StatefulWidget {
  final Cars cars;

  GoogleMaps({Key key, this.cars}) : super(key: key);

  @override
  _GoogleMapsState createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  final double zoom = 10;
  double bearing = 0.0;
  Set<Marker> markers = {};
  List<Marker> markers2 = new List();

  Cars cars;

  BitmapDescriptor taxiIcon;

  BitmapDescriptor poolIcon;

  GoogleMapController controller;

  @override
  void initState() {
    print('map google');

    cars = widget.cars;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(128, 128)), taxiBitmapPath)
        .then((onValue) {
      print('onValue.toString()');
      setState(() {
        taxiIcon = onValue;
      });
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(128, 128)), poolBitmapPath)
        .then((onValue) {
      print('onValue.toString()');
      setState(() {
        poolIcon = onValue;
      });
    });

    if (cars != null && cars.poiList.length > 0) setMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget map = StreamBuilder(
      stream: carsBloc.filterCars,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          cars = snapshot.data;
          setMarkers();
          return GoogleMap(
            markers: markers,
            myLocationEnabled: true,
            initialCameraPosition: new CameraPosition(
                target: LatLng(30.034057, 31.076022), zoom: zoom),
            onMapCreated: onMapCreated,
            onTap: (latLang) {
              poiListBloc.getPoiList(null);
            },
          );
        }
        return GoogleMap(
          markers: markers,
          myLocationEnabled: true,
          initialCameraPosition: new CameraPosition(
              target: LatLng(30.034057, 31.076022), zoom: zoom),
          onMapCreated: onMapCreated,
          onTap: (latLang) {
            poiListBloc.getPoiList(null);
          },
        );
      },
    );

    return StreamBuilder(
      stream: poiListBloc.selectPoiList,
      builder: (context, AsyncSnapshot snapshot) {
        print('here');
        setMarkers();
        if (snapshot.hasData) {
          print('data');
          if (snapshot.data.id > 0) {
            setMarkers();
            PoiList p = snapshot.data;
            controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    target: new LatLng(
                        p.coordinate.latitude, p.coordinate.longitude),
                    zoom: 12)));
//            markers.clear();
          }
        }
        if (snapshot.data != null && snapshot.data.id == 0) {
          print('error');
//          markers.clear();
        }

        return map;
      },
    );
  }

  void setMarkers() {
    print('google map set markers');
    markers.clear();
    cars.poiList.forEach((p) {
      addMarker(p);
    });

    print('markers ${markers.length}');
  }

  void addMarker(PoiList p) {
    markers.add(Marker(
        markerId: MarkerId(p.id.toString()),
        position: new LatLng(p.coordinate.latitude, p.coordinate.longitude),
        icon: p.fleetType == 'POOLING' ? poolIcon : taxiIcon,
        rotation: p.heading,
        flat: true,
        anchor: Offset(0.5, 0.5),
        onTap: () {
          print('google map marker taped ${p.id}');
          poiListBloc.getPoiList(p);
        },
        infoWindow: InfoWindow(
            title: p.id.toString(),
            snippet: p.fleetType,
            anchor: Offset(0.5, 0.5),
            onTap: () {
              print('google map info window taped ${p.id}');
            })));
  }

  onMapCreated(GoogleMapController controller) {
    this.controller = controller;
    print('created');
    if (cars != null && cars.poiList.length > 0) setMarkers();
  }
}
