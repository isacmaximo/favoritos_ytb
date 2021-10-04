//O bloc vai ser a ponte entre os widgets e a API

//para que o bloc possa ser acessado de qualquer local vai ser colocado em um BlocProvider
//que vai englobar o material app,


import 'dart:async';
import 'dart:ui';
import 'package:favoritos/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos/models/video.dart';

class VideosBloc implements BlocBase{

  Api api;

  //A lista de vídeos vai ser colocada dentro de _videosController,
  //que vai ser passado para a stream , que vai passar para o outVideos,
  // permitindo que a saída (outVideos) possa ser acessado de fora
  List<Video> videos;

  //sempre temos que fechar a stream, no caso vai ser no dispose()
  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  //_searchController vai o controlador da pesquisa e sua entrada (inSearch) poderá ser acessada de fora
  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc(){
    api = Api();

    //inSearch vai receber alguma pesquisa, e vai "notificar" a função _search,
    //em _search vai fazer a pesquisa e retornar os vídeos (lista de vídeos)
    _searchController.stream.listen(_search);

  }

  //função de pesquisa
  void _search(String search) async{

    if (search != null){
      //para que quando houver uma nova pesquisa, uma lista vazia será colocada
      //pois quando fazemos uma nova pesquisa, se estiver no meio da lista carregada,
      //ele tenta carregar o resto e depois faz a pesquisa (mostrar o resultado da outra pesquisa)
      _videosController.sink.add([]);

      videos = await api.search(search);
    }

    else{
      videos += await api.nextPage();
    }

   _videosController.sink.add(videos);

  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }

}