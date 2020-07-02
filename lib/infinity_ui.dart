import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class InfinityUi {
  static const MethodChannel _channel =
      const MethodChannel('infinity_ui');

  static bool _isEnable = false;
  static double _statusBarHeight, _statusLSBarHeight, _navigationBarHeight = 0.0;

  static bool get isEnable => _isEnable;
  static double get statusBarHeight => _statusBarHeight > 0 ? _statusBarHeight : 0;
  static double get statusLSBarHeight => _statusLSBarHeight > 0 ? _statusLSBarHeight : 0;
  static double get navigationBarHeight => _navigationBarHeight > 0 ? _navigationBarHeight : 0;

  // ignore: close_sinks
  static StreamController<List<double>> _changeController = StreamController<List<double>>.broadcast();
  static StreamSink<List<double>> get _sinkChangeController => _changeController.sink;
  static Stream<List<double>> get changeController => _changeController.stream;

  static Future<List<double>> enableInfinity() async {
    if (isEnable) {
      return [_statusBarHeight, _statusLSBarHeight, _navigationBarHeight];
    }
    final sizes = await _channel.invokeMethod('enableInfinity');
    _isEnable = true;
    _statusBarHeight = sizes[0];
    _statusLSBarHeight = sizes[1];
    _navigationBarHeight = sizes[2];
    _sinkChangeController.add([_statusBarHeight, _statusLSBarHeight, _navigationBarHeight]);
    return [_statusBarHeight, _statusLSBarHeight, _navigationBarHeight];
  }

  static Future<void> disableInfinity() async {
    if (!isEnable) {
      return [0.0, 0.0, 0.0];
    }
    await _channel.invokeMethod('disableInfinity');
    _isEnable = false;
    _statusBarHeight = 0;
    _statusLSBarHeight = 0;
    _navigationBarHeight = 0;
    _sinkChangeController.add([0, 0, 0]);
  }
}

class SafeInfinityUi extends StatefulWidget {

  final Widget background, child, navigationBarBackground, statusBarBackground;

  const SafeInfinityUi({
    Key key,
    @required this.background,
    this.child, 
    this.navigationBarBackground,
    this.statusBarBackground,
  })
  :
  assert(background != null),
  super(key: key);

  @override
  _SafeInfinityUiState createState() => _SafeInfinityUiState();
}

class _SafeInfinityUiState extends State<SafeInfinityUi> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
      stream: InfinityUi.changeController,
      builder: (context, snapshot) {
        return NativeDeviceOrientationReader(
          builder: (context) {
            print(InfinityUi.statusBarHeight);
            NativeDeviceOrientation or = NativeDeviceOrientationReader.orientation(context);
            EdgeInsets margin = EdgeInsets.only(
              top: InfinityUi.statusBarHeight,
              bottom: InfinityUi.navigationBarHeight,
            );
            Map<String, double> navPos = {
              'top': null,
              'bottom': 0,
              'left': 0,
              'right': 0,
              'height': InfinityUi.navigationBarHeight,
              'width': null,
            };
            if (InfinityUi.navigationBarHeight > 20)
            switch (or) {
              case NativeDeviceOrientation.landscapeRight:
                margin = EdgeInsets.only(
                  top: InfinityUi.statusLSBarHeight,
                  left: InfinityUi.navigationBarHeight,
                );
                navPos = {
                  'right': null,
                  'left': 0,
                  'bottom': 0,
                  'top': 0,
                  'height': null,
                  'width': InfinityUi.navigationBarHeight,
                };
                break;
              case NativeDeviceOrientation.landscapeLeft:
                margin = EdgeInsets.only(
                  top: InfinityUi.statusLSBarHeight,
                  right: InfinityUi.navigationBarHeight,
                );
                navPos = {
                  'left': null, 
                  'right': 0,
                  'bottom': 0,
                  'top': 0,
                  'height': null,
                  'width': InfinityUi.navigationBarHeight,
                };
                break;
              default:
                break;
            }
            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                widget.background,
                Container(
                  margin: margin,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ClipRRect(child: widget.child),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: or == NativeDeviceOrientation.landscapeLeft ||
                          or == NativeDeviceOrientation.landscapeRight ?
                          InfinityUi.statusLSBarHeight : InfinityUi.statusBarHeight,
                  child: ClipRRect(
                    child: widget.statusBarBackground,
                  )
                ),
                Positioned(
                  top: navPos['top'],
                  bottom: navPos['bottom'],
                  left: navPos['left'],
                  right: navPos['right'],
                  width: navPos['width'],
                  height: navPos['height'],
                  child: ClipRRect(
                    child: widget.navigationBarBackground,
                  )
                ),
              ],
            );
          },
        );
      },
    );
  }
}