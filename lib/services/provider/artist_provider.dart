import 'package:flutter/material.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';

import '../network/api_service.dart';

class ArtistProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<List<Artist>> getArtist() async {
    const String apiEndPoint = '/artists';
    isLoading = true;
    List<Artist> artists = await getArtists(apiEndPoint);

    isLoading = false;
    notifyListeners();
    return artists;
  }
}
