import 'package:flutter/material.dart';
import 'package:spooky_bloc/views/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "bloc",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff7f7f8),
        colorScheme: const ColorScheme.dark(
          primary: const Color(0xff5ca4a9),
          surface: const Color(0xff1e1e2c),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xffed6a5a),
          elevation: 4.0,
          centerTitle: true,

        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: "DMSerif",
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const Home(),
    );
  }
}
