import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
class AlbumProvider extends ChangeNotifier {
  bool isLoading = false;
  static const _pageSize = 10;
  List<Album> albums = [];

  Future<List<Album>> getAlbum() async {
    const String apiEndPoint = '/albums';
    isLoading = true;
    List<Album> albums = await getAlbums(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return albums;
  }
}
