import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:taxi_app_bloc/const.dart';
import 'package:taxi_app_bloc/models/cars_model.dart';
import 'package:taxi_app_bloc/resources/repository.dart';

class CarsBloc {
  final _repository = Repository();
  final _carsFetcher = PublishSubject<Cars>();
  final _filterFetcher = PublishSubject<Cars>();

  Cars cars,
      poolCars = new Cars(poiList: new List()),
      taxiCars = new Cars(poiList: new List());

  Observable<Cars> get allCars => _carsFetcher.stream;

  Observable<Cars> get filterCars => _filterFetcher.stream;

  getCars() async {
    Cars cars = await _repository.getCars();
    this.cars = cars;
    this.poolCars.poiList =
        cars.poiList.where((p) => p.fleetType == poolText).toList();
    this.taxiCars.poiList =
        cars.poiList.where((p) => p.fleetType == taxiText).toList();
    _carsFetcher.sink.add(cars);
  }

  getFilteredCars(String filter) async {
    print('filtercars $filter');
    if (filter == poolText)
      _filterFetcher.sink.add(poolCars);
    else if (filter == taxiText)
      _filterFetcher.sink.add(taxiCars);
    else
      _filterFetcher.sink.add(cars);

//    _filterFetcher.sink.add(cars);
  }

  dispose() {
    _carsFetcher.close();
    _filterFetcher.close();
  }
}

final carsBloc = CarsBloc();
