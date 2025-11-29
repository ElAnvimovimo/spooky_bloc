import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spooky_bloc/views/app.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    pantalla();
  }

  if (Platform.isAndroid || Platform.isIOS) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(const App());
}

void pantalla() {
  //tamanio default y minimo
  const double targetWidth = 600;
  const double targetHeight = 850;

  getWindowInfo().then((window) {
    final Screen? screen = window.screen;
    if (screen != null) {
      final Rect screenFrame = screen.visibleFrame;

      final double width = math.min(targetWidth, screenFrame.width);
      final double height = math.min(targetHeight, screenFrame.height);
      final double left = screenFrame.left + (screenFrame.width - width) / 2;
      final double top = screenFrame.top + (screenFrame.height - height) / 2;

      setWindowFrame(Rect.fromLTWH(left, top, width, height));
      setWindowMinSize(const Size(350, 500));

      setWindowMaxSize(Size.infinite);

      setWindowTitle("Spooky :)");
    }
  });
}