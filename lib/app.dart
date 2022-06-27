import 'package:flutter/material.dart';
import 'package:spotiblock/presentation/home_screen.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/home': (BuildContext context) => const HomeScreen(),
      },
      initialRoute: '/home',
    );
  }
}
