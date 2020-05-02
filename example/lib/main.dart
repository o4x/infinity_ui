import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinity_ui/infinity_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InfinityUi.enableInfinity();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ImageProvider iran, usa;
  Brightness brightness;

  @override
  void initState() {
    super.initState();
    brightness = Brightness.dark;
    iran = AssetImage('assets/iran.jpg');
    usa = AssetImage('assets/usa.jpg');
  }

  _switch(_) async {
    if (InfinityUi.isEnable) {
      await InfinityUi.disableInfinity();
      brightness = Brightness.light;
    } else {
      await InfinityUi.enableInfinity();
      brightness = Brightness.dark;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      systemNavigationBarIconBrightness: brightness,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeInfinityUi(
        background: Image(
          image: InfinityUi.isEnable ? usa : iran,
          fit: BoxFit.cover,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 300,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 50),
              color: Colors.white.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    InfinityUi.isEnable ?
                    'Enjoy freedom.'
                    :
                    '''You can also enjoy freedom here.
                    (ا سر بغل)''',
                    textScaleFactor: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Switch InfinityUi'),
                      Switch(
                        activeColor: Colors.black,
                        value: InfinityUi.isEnable,
                        onChanged: _switch,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}