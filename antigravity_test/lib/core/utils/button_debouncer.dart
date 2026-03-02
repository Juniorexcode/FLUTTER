import 'dart:async';
import 'package:flutter/foundation.dart';

class ButtonDebouncer {
  final int milliseconds;
  bool _isReady = true;
  Timer? _timer;

  ButtonDebouncer({this.milliseconds = 500});

  void run(VoidCallback action) {
    if (_isReady) {
      action();
      _isReady = false;
      _timer = Timer(Duration(milliseconds: milliseconds), () {
        _isReady = true;
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
