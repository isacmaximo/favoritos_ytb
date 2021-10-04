//Favoritos do Youtube

//CHECAR:
//* Plugins inseridos no pubspec.yaml
//* Diretório images


import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos/api.dart';
import 'package:favoritos/blocs/favorite_bloc.dart';
import 'package:favoritos/blocs/videos_bloc.dart';
import 'package:favoritos/screens/home.dart';
import 'package:flutter/material.dart';

void main() {

  runApp(MyApp());

}

//BlocProvider > MaterialApp

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(

        bloc: FavoriteBloc(),
        child:  MaterialApp(
          title: "FlutterTube",
          home: Home(),
        ),

      )

    );
  }
}
