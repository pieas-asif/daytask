import 'package:daytask/models/constants.dart';
import 'package:daytask/views/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day Task',
      theme: ThemeData(
        fontFamily: "UbuntuMono",
        colorScheme: const ColorScheme.light(
          primary: DTTheme.foreground, // header background color
          onPrimary: DTTheme.background, // header text color
          onSurface: DTTheme.foreground, // body text color
          background: DTTheme.foreground,
          secondary: DTTheme.foreground,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            primary: DTTheme.foreground, // button text color
          ),
        ),
      ),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
      },
    );
  }
}
