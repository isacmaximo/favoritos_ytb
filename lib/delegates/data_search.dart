
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Sistema de busca:
//Como queremos pesquisar um texto, então colocamos String no SearchDelegate
//São quatro métodos no DataSearch:
//buildActions: vai ser o ícone de apagar a pesquisa (um X) - lado direito
//buildLeading: vai ser o botão animado de voltar (seta de voltar) - lado esquerdo
//buildResult: vai pegar o que foi digitado e retornar para a tela de vídeos (Home)
//buildSuggestions: vão ser as sugestões de pesquisa


class DataSearch extends SearchDelegate<String>{

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    Future.delayed(Duration.zero).then((_) =>  close(context, query));

    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(query.isEmpty){
      return Container();
    }

    else{
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot){

          if (!snapshot.hasData){
            return Center( child: CircularProgressIndicator(),);
          }

          else{
            return ListView.builder(
              itemBuilder: (context, index){
                return ListTile(
                  title: snapshot.data[index],
                  leading: Icon(Icons.play_arrow),
                  onTap: (){
                    close(context, snapshot.data[index]);
                  },
                );
              },
              itemCount: snapshot.data.length,
            );
          }

        },
      );
    }

  }

  //aqui será a função suggestions que irá mostar as sugestões confome a a digitação da pesquisa
  //para que isso aconteça vai ocorrer uma requisição,que vai retornar as sugestões
  //se o response.statusCode retornar 200, quer dizer que deu certo a requisição
  //irá pegar o arquivo json contendo as sugestões e irá retornar em formato de lista
  //se der errado então retorna um erro
  Future<List> suggestions(String search) async{
    http.Response response = await http.get(Uri.parse(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    ));

    if(response.statusCode == 200){
      //caminho das sugestões: [1] > value[0]
      //[1] é onde estão as sugestões, dentro de onde estão as sugestões as strings de sugestões estão em [0]
      json.decode(response.body)[1].map((value){
        return value[0];
      }).toList();
    }

    else{
      throw Exception("Failed to load suggestions");
    }

  }

}