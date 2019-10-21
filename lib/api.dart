import 'package:dio/dio.dart';

import 'models/cars_model.dart';

class API {
  Response response;
  Dio dio = new Dio(new BaseOptions(
      baseUrl:
          'https://fake-poi-api.mytaxi.com/?p1Lat=30.129610&p1Lon=30.864947&p2Lat=29.824722&p2Lon=31.519720'));

  Future<Cars> getCars() async {
    response = await dio.get('');
    if (response.statusCode == 200) {
      print('api success ${response.data.toString()}');
      Cars cars = Cars.fromJson(response.data);
      return cars;
    } else {
      print('api error');
      return null;
    }
  }
}
