//Home Screen

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos/blocs/favorite_bloc.dart';
import 'package:favoritos/blocs/videos_bloc.dart';
import 'package:favoritos/delegates/data_search.dart';
import 'package:favoritos/models/video.dart';
import 'package:favoritos/screens/favorites.dart';
import 'package:favoritos/widgets/video_tile.dart';
import 'package:flutter/material.dart';

//o título da home será uma imagem (logo do youtube)
//appbar de fundo preto, texto com a quantidade de favoritos, botão de ação estrela (favoritos), botão de ação pesquisa

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    //bloc provider
    final bloc = BlocProvider.of<VideosBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube.png"),

        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[

          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.of<FavoriteBloc>(context).outFav,
              initialData: {},
              builder: (context, snapshot){

                //mostrando a quantidade de favoritos
                if (snapshot.hasData){
                  return Text("${snapshot.data.length}");
                }

                else{
                  return Container();
                }

              },
            ),
          ),

          IconButton(
          icon: Icon(Icons.star),
          onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Favorites())
            );
          }),

          IconButton(
           icon: Icon(Icons.search),
           onPressed: () async{
             String result = await showSearch(context: context, delegate: DataSearch());

             if(result != null){
               bloc.inSearch.add(result);
             }

           }),


        ],
      ),
      backgroundColor: Colors.black87,
      //aqui no corpo da home mostrará os vídeos
      body: StreamBuilder(
        stream: bloc.outVideos,
        builder: (context, snapshot){

          if(snapshot.hasData){
            return ListView.builder(
              itemBuilder: (context, index){

                //último bloco vai ser o 9
                if (index < snapshot.data.length){
                  return VideoTile(snapshot.data[index]);
                }

                //o que ficou nulo agora é uma indicador circular de progresso
                else if (index > 1){
                  bloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }

                else{
                  return Container();
                }

              },
              //colocamos + 1 para o que o programa ache que tenha 1 ítem a mais
              //fazendo com que sempre carregue mais ítens
              itemCount: snapshot.data.length + 1,
            );
          }

          else{
            return Container();
          }

        },
      ),

    );

  }
}
