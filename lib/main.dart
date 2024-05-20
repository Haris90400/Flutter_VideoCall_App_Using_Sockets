import 'package:chatify/pages/login_page.dart';
import 'package:chatify/pages/splash_page.dart';
import 'package:chatify/services/navigation_service.dart';

import 'package:flutter/material.dart';

void main() async {
  runApp(
    SplashScreen(
      key: UniqueKey(),
      onInitializationComplete: () {
        runApp(
          MainApp(),
        );
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(37, 35, 41, 1),
        scaffoldBackgroundColor: Color.fromRGBO(50, 48, 58, 1),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(30, 29, 37, 1.0),
        ),
      ),
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/login',
      routes: {
        '/login': (BuildContext context) {
          return LoginPage();
        }
      },
    );
  }
}
