import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simpletodo/constants/app_settings.dart';
import 'package:simpletodo/extensions/app_lang.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoadingWidget(),
      debugShowCheckedModeBanner: false,
      theme: AppSettings.defaultTheme,
      supportedLocales: AppSettings.supportedLocales,
      localizationsDelegates: AppSettings.localizationsDelegates,
      localeResolutionCallback: AppSettings.localeResolutionCallback,
    );
  }
}

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  LoadingWidgetState createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Timer _timer;
  double _progressVal = 0.0;

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          updateProgress();
        },
      ),
    );

    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 90.0)),
            CircularProgressIndicator(
              value: _progressVal,
              valueColor: animationController.drive(ColorTween(
                begin: Colors.deepOrangeAccent,
                end: Colors.deepOrange,
              )),
              backgroundColor: Colors.black,
              strokeWidth: 1,
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            Text(
              context.translate.loading,
              style: const TextStyle(fontSize: 16.0, color: Colors.deepOrange),
            ),
          ],
        ),
      ),
    );
  }

  void updateProgress() {
    if (_progressVal == 1.0) {
      _progressVal = 0.1;
    } else {
      _progressVal += 0.2;
    }
  }
}
