import 'package:flutter/material.dart';
import 'package:peaman/views/screens/home_screen.dart';

void main(){
  runApp(PeamanApp());
}

class PeamanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Peaman",
      theme: ThemeData(
        fontFamily: 'Nunito'
      ),
      home: Material(
        child: HomeScreen(),
      ),
    );
  }
}