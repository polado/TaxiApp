import 'package:rxdart/rxdart.dart';
import 'package:taxi_app_bloc/models/poilist_model.dart';

class PoiListBloc {
  final _poiListFetcher = PublishSubject<PoiList>();
  final _poiListRemover = PublishSubject<PoiList>();
  final _poiListRefresh = PublishSubject<int>();

  Observable<PoiList> get selectPoiList => _poiListFetcher.stream;

  Observable<PoiList> get removePoiList => _poiListRemover.stream;

  Observable<int> get refreshPoiList => _poiListRefresh.stream;

  getPoiList(PoiList poiList) {
    _poiListFetcher.sink.add(poiList);
  }

  removePoList(PoiList poiList) {
//    print('bloc poilist remove');
    _poiListRemover.sink.add(poiList);
  }

  refreshThePoiList() {
    _poiListRefresh.sink.add(0);
  }

  dispose() {
    _poiListFetcher.close();
    _poiListRemover.close();
    _poiListRefresh.close();
  }
}

final poiListBloc = PoiListBloc();
