import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:nafila_mouride_vision/accueil.dart';
import 'package:nafila_mouride_vision/quran.dart';

import 'hom_service.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/logo_MV.png',
      nextScreen: const HomePage(),
      duration: 3000,
      splashIconSize: 500,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color(0xff08716a),
    );
  }
}
