import 'package:flutter/material.dart';
import 'package:infinity_ui/infinity_ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeInfinityUi(
        background: Container(),
        navigationBarColor: Colors.amber.withOpacity(0.5),
        statusBarColor: Colors.amber.withOpacity(0.5),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Container(color: Colors.blue),
        ),
      ),
    );
  }
}