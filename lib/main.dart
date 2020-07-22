import 'package:flutter/material.dart';
import 'package:peaman/wrapper.dart';
import 'package:peaman/wrapper_builder.dart';

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
        child: WrapperBuilder(
          builder: (BuildContext context){
            return Wrapper();
          },
        ),
      ),
    );
  }
}