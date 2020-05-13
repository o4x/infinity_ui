import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class InfinityUi {
  static const MethodChannel _channel =
      const MethodChannel('infinity_ui');

  static bool _isEnable = false;
  static double _statusBarHeight = 0;
  static double _navigationBarHeight = 0;
  static double _navigationBarWidth = 0;

  static bool get isEnable => _isEnable;
  static double get statusBarHeight => _statusBarHeight;
  static double get navigationBarHeight => _navigationBarHeight;
  static double get navigationBarWidth => _navigationBarWidth;

  static StreamController<List<double>> _changeController = StreamController<List<double>>.broadcast();
  static StreamSink<List<double>> get _sinkChangeController => _changeController.sink;
  static Stream<List<double>> get changeController => _changeController.stream;

  static Future<List<double>> enableInfinity() async {
    final sizes = await _channel.invokeMethod('enableInfinity');
    _isEnable = true;
    _statusBarHeight = sizes[0];
    _navigationBarHeight = sizes[1];
    _navigationBarWidth = sizes[2];
    _sinkChangeController.add([_statusBarHeight, _navigationBarHeight, _navigationBarWidth]);
    return [_statusBarHeight, _navigationBarHeight, _navigationBarWidth];
  }

  static Future<void> disableInfinity() async {
    await _channel.invokeMethod('disableInfinity');
    _isEnable = false;
    _statusBarHeight = 0;
    _navigationBarHeight = 0;
    _navigationBarWidth  = 0;
    _sinkChangeController.add([0, 0, 0]);
  }
}

class SafeInfinityUi extends StatelessWidget {

  final Widget background;
  final Widget child;
  final Color navigationBarColor;
  final Color statusBarColor;

  SafeInfinityUi({
    Key key,
    @required this.background,
    this.child,
    this.navigationBarColor = Colors.transparent,
    this.statusBarColor = Colors.transparent,
  })
  :
  assert(background != null),
  super(key: key);

  NativeDeviceOrientation lastOrientation;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: InfinityUi.changeController,
      builder: (context, snapshot) {
        return NativeDeviceOrientationReader(
          builder: (context) {
            if (
              InfinityUi.isEnable &&
              lastOrientation != null && 
              NativeDeviceOrientationReader.orientation(context) != lastOrientation
            ) {
              InfinityUi.enableInfinity();
            }
            EdgeInsets margin = EdgeInsets.only(
              top: InfinityUi.statusBarHeight,
              bottom: InfinityUi.navigationBarHeight,
            );
            lastOrientation = NativeDeviceOrientationReader.orientation(context);
            Map<String, double> navPos = {
              'top': null,
              'bottom': 0,
              'left': 0,
              'right': 0,
              'height': InfinityUi.navigationBarHeight,
              'width': null,
            };
            switch (NativeDeviceOrientationReader.orientation(context)) {
              case NativeDeviceOrientation.landscapeRight:
                margin = EdgeInsets.only(
                  top: InfinityUi.statusBarHeight,
                  left: InfinityUi.navigationBarWidth,
                );
                navPos = {
                  'right': null,
                  'left': 0,
                  'bottom': 0,
                  'top': 0,
                  'height': null,
                  'width': InfinityUi.navigationBarWidth,
                };
                break;
              case NativeDeviceOrientation.landscapeLeft:
                margin = EdgeInsets.only(
                  top: InfinityUi.statusBarHeight,
                  right: InfinityUi.navigationBarWidth,
                );
                navPos = {
                  'left': null, 
                  'right': 0,
                  'bottom': 0,
                  'top': 0,
                  'height': null,
                  'width': InfinityUi.navigationBarWidth,
                };
                break;
              default:
                break;
            }
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                background,
                Container(
                  margin: margin,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: child,
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: InfinityUi.statusBarHeight,
                  child: Container(color: statusBarColor)
                ),
                Positioned(
                  top: navPos['top'],
                  bottom: navPos['bottom'],
                  left: navPos['left'],
                  right: navPos['right'],
                  width: navPos['width'],
                  height: navPos['height'],
                  child: Container(color: navigationBarColor)
                ),
              ],
            );
          },
        );
      },
    );
  }
}