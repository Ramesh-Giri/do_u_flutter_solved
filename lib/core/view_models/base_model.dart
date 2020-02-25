import 'package:flutter/widgets.dart';
import '../enums.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  String errorMessage = "";

  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  onDispose() {}
}
