//API

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/video.dart';

//chave de API do youtube:
const API_KEY = "AIzaSyDpp4HxIA3GiO87lxpvvaQLyWwxyI4tmn0";

class Api{

  String _search;
  String _nextToken;

  //função que vai receber a pesquisa:
  Future<List<Video>> search(String search) async{

    //_search vai receber o que foi pesquisado (search)
    _search = search;

    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    ));

    return decode(response);

  }

  //função que vai criar a próxima página
  //vai receber a pesquisa e o token para que gere a nova página
  Future<List<Video>> nextPage() async{
    http.Response response = await http.get(Uri.parse(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    ));

    return decode(response);
  }

  //o decode vai verificar se recebeu o código 200, ou seja que recebeu os dados com sucesso
  //se tudo deu certo então ele pega essas informações e transforma em json
  //depois irá transformar o json em uma lista (objetos - vídeo) => para isso um modelo (video) será criado
  //"items" é uma lista de mapas, e esse mapa é transformado no modelo Video,
  // depois é transformado em uma lista de vídeos, e pro fim é retornada a lista de vídeos
  //se der errado é retornado um erro
  //_nextToken é o token necessário para o  carregamento da próxima página

  decode(http.Response response){

    if (response.statusCode == 200){

      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      List<Video> videos = decoded["items"].map<Video>((map){
        return Video.fromJson(map);
      }).toList();

      return videos;
    }

    else{
      throw Exception("Failed to load videos");
    }

  }

}