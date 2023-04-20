import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_service.dart';

class PlayListProvider extends ChangeNotifier {
  bool isLoading = false;
  late int isFavorite;
  List<PlaylistTitle> musics = [];

  Future<List<PlaylistTitle>> getPlayList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    print('mid id is $id');
    String apiEndPoint = '/music/playlistTitle/$id';
    isLoading = true;
    musics = await getPlayLists(apiEndPoint);
    isLoading = false;
    notifyListeners();
    return musics;
  }

  Future createPlayList(title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint = '/create/playlistTitle';
    var playlist = {'title': title, 'clientId': id};
    isLoading = true;
    notifyListeners();
    var result = await createPlaylist(apiEndPoint, json.encode(playlist));
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<List<PlayListTitles>> getPlayListTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id');
    String apiEndPoint = '/playlistTitle/only/$id';
    isLoading = true;
    List<PlayListTitles> titles = await getPlayListTitles(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return titles;
  }

  Future<bool> addMusicToPlaylist(playlistInfo) async {
    String apiEndPoint = '/music/addToPlayList';
    isLoading = true;
    var result = await addToPlaylist(apiEndPoint, playlistInfo);
    isLoading = false;
    notifyListeners();
    return result;
  }

  Future deleteFromPlaylist(playlistId) async {
    await removeFromPlaylist('/music/removeFromPlaylist/$playlistId');
    for (var element in musics) {element.playlists.removeWhere((element) => element.id==playlistId);}
    notifyListeners();
  }

  Future deletePlaylistTitle(playlistTitleId) async{
    await removePlaylistTitle('/delete/playlistTitle/$playlistTitleId');
    musics.removeWhere((element) => element.id==playlistTitleId);
    notifyListeners();
  }
}
