import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/api_service.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteMusicProvider extends ChangeNotifier{
  bool isLoading = false;
  int isFavorite =0;
  List<Favorite> favoriteMusics = [];
  Future<List<Favorite>> getFavMusic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint = '/musics/favorite/$id';
    isLoading = true;
    notifyListeners();
    favoriteMusics = await getFavoriteMusics(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return favoriteMusics;
  }

  void unMarkMusic(favMusicId) async {
    String apiEndPoint = '/music/unmark/$favMusicId';
    await deleteFavMusic(apiEndPoint);
    favoriteMusics.removeWhere((element) => element.id==favMusicId);
    isFavorite = 0;
    notifyListeners();
  }
  void unFavMusic(musicId) async {
    isFavorite = 0;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint = '/music/unfav/client/$id/music/$musicId';
    await deleteFavMusic(apiEndPoint);
  }
  void favMusic(musicId) async {
    isFavorite = 1;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint = '/markusFavorite/client/$id/music/$musicId';
    await markusFavMusic(apiEndPoint);
  }

  Future<int> isMusicFav(musicId)async{
    isFavorite = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint  = '/ismusicFavorite/client/$id/music/$musicId';
    isFavorite = await isMusicFavorite(apiEndPoint);
    print('Is music fav $isFavorite}');
    notifyListeners();
    return isFavorite;
  }
}

