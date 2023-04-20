import 'dart:convert';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/artist.dart';
import 'package:kin_music_player_app/services/network/model/companyProfile.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:kin_music_player_app/services/network/model/genre.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_title.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcast_category.dart';
import 'package:kin_music_player_app/services/network/model/radio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../constants.dart';
import 'model/user.dart';

Future<String> createAccount(apiEndPoint, user) async {
  try {
    Response response = await post(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
      body: json.encode(user),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      var token = json.decode(response.body)['token'];
      var name = json.decode(response.body)['user']['name'];
      var email = json.decode(response.body)['user']['email'];
      var id = json.decode(response.body)['user']['id'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('name$id', name);
      await prefs.setString('email$id', email);
      await prefs.setInt('id', id);
      return "Successfully Registered";
    } else {
      var error = json.decode(response.body)['errors'];
      print('error is ${json.decode(response.body)}');
      if (error['email'] != null) {
        return error['email'].toString();
      } else if (error['password'] != null) {
        return error['password'].toString();
      }
      return 'Unknown Error Occurred';
    }
  } catch (e) {
    rethrow;
  }
}

Future logIn(apiEndPoint, user) async {
  try {
    Response response = await post(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
      body: user,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      var body = json.decode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = body['user']['id'];
      await prefs.setString('token', body['token']);
      await prefs.setString('name$id', body['user']["name"]);
      await prefs.setString('email$id', body['user']['email'] ?? '');
      await prefs.setInt('id', id);
      return "Successfully Logged In";
    } else {
      return 'bad credentials';
    }
  } catch (e) {
    rethrow;
  }
}

Future loginWithFacebook(apiEndPoint) async {
  // var result =
  // await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
  var user;
  final LoginResult loginResult = await FacebookAuth.instance.login();
  if (loginResult.status == LoginStatus.success) {
    final auth.OAuthCredential facebookAuthCredential = auth.FacebookAuthProvider.credential(loginResult.accessToken!.token);

    auth.UserCredential result = await auth.FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = User(
        name: result.user!.displayName??'',
        id: 2,
        email: result.user!.email?? '${result.user!.email}@kinMusic',
        password: 'kin@Music',
        loginMode:'facebook',
        passwordConfirmation: 'kin@Music');
    Response response = await post(
      Uri.parse("$apiUrl/api/register"),
      body: json.encode(user),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      prefs.remove('id');
      var id = json.decode(response.body)['user']['id'];
      await prefs.setInt('id', id);
      await prefs.setString('token', loginResult.accessToken!.token);
      await prefs.setString('name$id', result.user!.displayName.toString());
      await prefs.setString('email$id',result.user!.email ?? '${result.user!.displayName}@kinMusic');
    }
  }
  return loginResult.status;
}
Future getMusic(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      List<Music> music = item.map((value) => Music.fromJson(value)).toList();
      return music;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future incrementMusicView(musicId) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = {'musicId': musicId, 'clientId': prefs.getInt('id')};
    Response response = await post(
      Uri.parse("$apiUrl/api/music/incrementView"),
      body: json.encode(data),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      return 'Successfully Incremented';
    } else {
      return 'Already added';
    }
  } catch (e) {
    rethrow;
  }
}

Future fetchMore(page) async {
  try {
    List<Music> musics;
    Response response =
        await get(Uri.parse("$apiUrl/api/musics/recent?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      musics = item.map((value) => Music.fromJson(value)).toList();
      return musics;
    }
  } catch (E) {
    rethrow;
  }
}

Future fetchMorePopular(page) async {
  try {
    List<Music> musics;
    Response response =
        await get(Uri.parse("$apiUrl/api/musics/popular?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      musics = item.map((value) => Music.fromJson(value)).toList();
      return musics;
    }
  } catch (e) {
    rethrow;
  }
}

Future fetchMoreAlbum(page) async {
  try {
    List<Album> albums;
    Response response = await get(Uri.parse("$apiUrl/api/albums?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      albums = item.map((value) => Album.fromJson(value)).toList();
      return albums;
    }
  } catch (E) {
    rethrow;
  }
}

Future fetchMoreCategories(page) async {
  try {
    List<PodCastCategory> categories;
    Response response =
        await get(Uri.parse("$apiUrl/api/podcast/categories?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      categories =
          item.map((value) => PodCastCategory.fromJson(value)).toList();
      return categories;
    }
  } catch (e) {
    rethrow;
  }
}

Future getAlbums(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<Album> albums = item.map((value) {
        return Album.fromJson(value);
      }).toList();
      return albums;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future getArtists(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<Artist> artists = item.map((value) {
        return Artist.fromJson(value);
      }).toList();
      return artists;
    } else {}
  } catch (e) {
    rethrow;
  }
}

Future getPlayLists(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<PlaylistTitle> playlists = item.map((value) {
        return PlaylistTitle.fromJson(value);
      }).toList();

      return playlists;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future getPlayListTitles(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<PlayListTitles> playlistTitles = item.map((value) {
        return PlayListTitles.fromJson(value);
      }).toList();
      return playlistTitles;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future addToPlaylist(apiEndPoint, playlistInfo) async {
  try {
    Response response = await post(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
      body: json.encode(playlistInfo),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (E) {
    rethrow;
  }
}

Future getFavoriteMusics(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<Favorite> musics = item.map((value) {
        return Favorite.fromJson(value);
      }).toList();

      return musics;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future deleteFavMusic(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future markusFavMusic(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future<int> isMusicFavorite(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      return (json.decode(response.body));
    } else {
      return 0;
    }
  } catch (E) {
    rethrow;
  }
}

Future createPlaylist(apiEndPoint, playlist) async {
  try {
    Response response = await post(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
      body: playlist,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );
    if (response.statusCode == 201) {
      return 'Successful';
    } else {
      return 'PlayList Title Already Exists';
    }
  } catch (e) {
    rethrow;
  }
}

Future removeFromPlaylist(apiEndPoint) async {
  try {
    Response response = await get(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    rethrow;
  }
}

Future removePlaylistTitle(apiEndPoint) async {
  try {
    Response response = await delete(
      Uri.parse("$apiUrl/api" "$apiEndPoint"),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (E) {
    rethrow;
  }
}

Future searchMusic(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<dynamic> musics = item.map((value) {
        return Music.fromJson(value);
      }).toList();
      return musics;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future getPodCasts(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      List<PodCast> podCasts = item.map((value) {
        return PodCast.fromJson(value);
      }).toList();
      return podCasts;
    } else {}
  } catch (e) {
    rethrow;
  }
}

Future fetchMorePodCasts(page) async {
  try {
    List<PodCast> podCasts;
    Response response = await get(Uri.parse("$apiUrl/api/podcasts?page=$page"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      podCasts = item.map((value) => PodCast.fromJson(value)).toList();
      return podCasts;
    }
  } catch (E) {
    rethrow;
  }
}

Future searchPodCast(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<dynamic> podcasts = item.map((value) {
        return PodCast.fromJson(value);
      }).toList();
      return podcasts;
    } else {
      return [];
    }
  } catch (E) {
    rethrow;
  }
}

Future getPodCastCategories(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body)['data'] as List;
      List<PodCastCategory> categories = item.map((value) {
        return PodCastCategory.fromJson(value);
      }).toList();
      return categories;
    } else {}
  } catch (E) {
    rethrow;
  }
}

Future<List<Genre>> getGenres(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<Genre> genres = item.map((value) {
        return Genre.fromJson(value);
      }).toList();

      return genres;
    } else {}
    return [];
  } catch (E) {
    rethrow;
  }
}

Future<dynamic> getCompanyProfile(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body);

      return CompanyProfile.fromJson(item);
    }
    return 'Unknown Error Occured';
  } catch (e) {
    rethrow;
  }
}

Future<List<RadioStation>> getRadioStations(apiEndPoint) async {
  try {
    Response response = await get(Uri.parse("$apiUrl/api" "$apiEndPoint"));
    if (response.statusCode == 200) {
      final item = json.decode(response.body) as List;
      List<RadioStation> stations = item.map((value) {
        return RadioStation.fromJson(value);
      }).toList();

      return stations;
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<bool> requestForgetPasswordService(resetInfo, String apiEndPoint) async {
  try{
    Uri url = Uri.parse("$apiUrl/api" "$apiEndPoint");
    try {
      Response response = await post(
        url,
        body: json.encode(resetInfo),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
      );

      print(
          'Forget Password Response is ${jsonDecode(response.statusCode.toString())}');
      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }catch(e){
    rethrow;
  }
}

Future<bool> resetPasswordService(resetInfo, apiEndPoint) async {

  try {
    Uri url = Uri.parse("$apiUrl/api" "$apiEndPoint");
    Response response = await post(
      url,
      body: json.encode(resetInfo),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
    );

    print('Reset status${response.statusCode} ');
    print('Reset status${response.body} ');
    if (response.statusCode == 200) {
      return true;
    }

    return false;
  } catch (e) {
    rethrow;
  }
}
