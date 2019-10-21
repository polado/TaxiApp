import 'package:taxi_app_bloc/api.dart';
import 'package:taxi_app_bloc/models/cars_model.dart';
class Repository {
  final api = API();

  Future<Cars> getCars() => api.getCars();
}