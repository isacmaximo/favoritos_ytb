//Bloc dos Favoritos

import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase{

  //mapa contendo os favoritos , modelo: Map<idVideo, Video>
  Map<String, Video> _favorites = {};

  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});

  Stream<Map<String, Video>> get outFav => _favController.stream;


  FavoriteBloc(){
    SharedPreferences.getInstance().then((prefs){
      //colocando os favoritos  no formato json
      if(prefs.getKeys().contains("favorites")){
        _favorites = json.decode(prefs.getString("favorites")).map((key,value){
          return MapEntry(key, Video.fromJson(value));
        }).cast<String, Video>();

        _favController.add(_favorites);
      }
    });
  }


  // função/método dos favoritos
  void toggleFavorite(Video video){

    if(_favorites.containsKey(video.id)){
      _favorites.remove(video.id);
    }

    else{
      _favorites[video.id] = video;
    }

    _favController.sink.add(_favorites);

    _saveFav();

  }


  void _saveFav(){
    SharedPreferences.getInstance().then((prefs){
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  //função de salvar os favoritos

  @override
  void dispose() {
    _favController.close();
  }


}