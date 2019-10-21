import 'poilist_model.dart';

class Cars {
  List<PoiList> poiList;

  Cars({this.poiList});

  Cars.fromJson(Map<String, dynamic> json) {
    if (json['poiList'] != null) {
      poiList = new List<PoiList>();
      json['poiList'].forEach((v) {
        poiList.add(new PoiList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.poiList != null) {
      data['poiList'] = this.poiList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
