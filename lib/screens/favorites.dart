//Tela dos Favoritos

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos/blocs/favorite_bloc.dart';
import 'package:favoritos/models/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:favoritos/api.dart';

class Favorites extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),

      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
        stream: bloc.outFav,
        initialData: {},
        builder: (context, snapshot){
          return ListView(
            children: snapshot.data.values.map((videos){
              return InkWell(
                onTap: (){
                  FlutterYoutube.playYoutubeVideoById(apiKey: API_KEY, videoId: videos.id);
                },
                onLongPress: (){
                  bloc.toggleFavorite(videos);
                },

                child: Row(
                  children: <Widget>[

                    Container(
                      width: 100,
                      height: 50,
                      child: Image.network(videos.thumb),
                    ),

                    Expanded(
                      child: Text(
                        videos.title, style: TextStyle(color: Colors.white70),
                        maxLines: 2,
                      ),
                    ),


                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
