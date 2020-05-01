import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfinityUi {
  static const MethodChannel _channel =
      const MethodChannel('infinity_ui');

  static bool _isEnable = false;
  static double _statusBarHeight = 0;
  static double _navigationBarHeight = 0;

  static bool get isEnable => _isEnable;
  static double get statusBarHeight => _statusBarHeight;
  static double get navigationBarHeight => _navigationBarHeight;

  static StreamController<List<double>> _changeController = StreamController<List<double>>.broadcast();
  static StreamSink<List<double>> get _sinkChangeController => _changeController.sink;
  static Stream<List<double>> get changeController => _changeController.stream;

  static Future<List<double>> enableInfinity() async {
    final heights = await _channel.invokeMethod('enableInfinity');
    _isEnable = true;
    _statusBarHeight = heights[0];
    _navigationBarHeight = heights[1];
    _sinkChangeController.add([_statusBarHeight, _navigationBarHeight]);
    return [_statusBarHeight, _navigationBarHeight];
  }

  static Future<void> disableInfinity() async {
    await _channel.invokeMethod('disableInfinity');
    _isEnable = false;
    _statusBarHeight = 0;
    _navigationBarHeight = 0;
    _sinkChangeController.add([0, 0]);
  }
}

class SafeInfinityUi extends StatelessWidget {

  final Widget background;
  final Widget child;
  final Color navigationBarColor;
  final Color statusBarColor;

  const SafeInfinityUi({
    Key key,
    @required this.background,
    this.child,
    this.navigationBarColor = Colors.transparent,
    this.statusBarColor = Colors.transparent,
  })
  :
  assert(background != null),
  super(key: key);


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: InfinityUi.changeController,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              background,
              Container(
                margin: EdgeInsets.only(bottom: snapshot.data[1], top: snapshot.data[0]),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: snapshot.data[0],
                child: Container(color: statusBarColor)
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: snapshot.data[1],
                child: Container(color: navigationBarColor)
              ),
            ],
          );
        }
        return Stack(
          fit: StackFit.expand,
          children: <Widget>[
            background,
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: child,
            ),
          ],
        );
      },
    );
  }
}