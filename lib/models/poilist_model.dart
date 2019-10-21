import 'coordinate_model.dart';

class PoiList {
  int id;
  Coordinate coordinate;
  String fleetType;
  double heading;


  PoiList({this.id, this.coordinate, this.fleetType, this.heading});

  PoiList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    coordinate = json['coordinate'] != null
        ? new Coordinate.fromJson(json['coordinate'])
        : null;
    fleetType = json['fleetType'];
    heading = json['heading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.coordinate != null) {
      data['coordinate'] = this.coordinate.toJson();
    }
    data['fleetType'] = this.fleetType;
    data['heading'] = this.heading;
    return data;
  }
}
