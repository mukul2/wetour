import 'dart:async';

class LocationSelected{
  static LocationSelected model =LocationSelected();
  final StreamController<List> _Controller = StreamController<List>.broadcast();

  Stream<List> get outData => _Controller.stream;

  Sink<List> get inData => _Controller.sink;

  dataReload(List v) {
    fetch().then((value) => inData.add(v));
  }

  void dispose() {
    _Controller.close();
  }

  static LocationSelected getInstance() {
    if (model == null) {
      model = new LocationSelected();
      return model;
    } else {
      return model;
    }
  }

  Future<void> fetch() async {
    return;
  }
}