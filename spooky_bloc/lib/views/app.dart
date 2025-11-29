import 'package:flutter/material.dart';
import 'package:spooky_bloc/views/home.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color iceBlue = Color(0xFFB8E3E9);
    const Color softGrey = Color(0xFF93B1B5);
    const Color tealSlate = Color(0xFF4F7C82);
    const Color deepGreen = Color(0xFF0B2E33);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "bloc",
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,

        scaffoldBackgroundColor: iceBlue,

        colorScheme: const ColorScheme.light(
          primary: deepGreen,
          onPrimary: Colors.white,
          secondary: tealSlate,
          surface: iceBlue,
          onSurface: deepGreen,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: deepGreen),
          titleTextStyle: TextStyle(
            fontFamily: "DMSerif",
            fontSize: 24,
            color: deepGreen,
            fontWeight: FontWeight.bold,
          ),
        ),

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontFamily: "DMSerif",
            fontSize: 24,
            color: deepGreen,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontFamily: "DMSerif",
            color: deepGreen,
            fontSize: 16,
          ),
        ),

        // 5. Tema de iconos
        iconTheme: const IconThemeData(
          color: deepGreen,
        ),
      ),
      home: const Home(),
    );
  }
}