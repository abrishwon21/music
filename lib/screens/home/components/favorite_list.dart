import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/favorite.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class FavoriteList extends StatelessWidget {
  const FavoriteList({
    Key? key,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.id,
    required this.musicIndex,
    required this.favoriteMusics,
    required this.music,
  }) : super(key: key);

  final double height, aspectRatio;
  final Music music;
  final int id;
  final int musicIndex;
  final List<Favorite> favoriteMusics;

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(
      context,
    );
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    List<Music> favoriteMusicsList = [];

    for (int i = 0; i < favoriteMusics.length; i++) {
      favoriteMusicsList.add(favoriteMusics[i].music);
    }
    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return Container(
              height: getProportionateScreenHeight(height),
              margin: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20),
                  vertical: getProportionateScreenHeight(10)),
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              p.setBuffering(musicIndex,music.id);
                              if(checkConnection(status)){
                                if (p.isMusicInProgress(music)) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          NowPlayingMusic(music)));
                                } else {
                                  radioProvider.player.stop();
                                  podcastProvider.player.stop();
                                  p.player.stop();

                                  p.setMusicStopped(true);
                                  podcastProvider.setEpisodeStopped(true);
                                  p.listenMusicStreaming();
                                  podcastProvider.listenPodcastStreaming();

                                  p.setPlayer(
                                      p.player, podcastProvider, radioProvider);
                                  radioProvider.setMiniPlayerVisibility(false);
                                  p.handlePlayButton(
                                      music: music,
                                      index: musicIndex,
                                      album: Album(
                                          id: -2,
                                          title: 'Single Music $musicIndex',
                                          artist: 'kin',
                                          description: '',
                                          cover: 'assets/images/kin.png',
                                          musics: favoriteMusicsList));

                                  p.setMusicStopped(false);
                                  podcastProvider.setEpisodeStopped(true);
                                  p.listenMusicStreaming();
                                  podcastProvider.listenPodcastStreaming();
                                }
                              }else{
                                kShowToast();
                              }

                            },
                            child: Row(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                      aspectRatio: 1.02,
                                      child: Container(
                                          color:
                                              kSecondaryColor.withOpacity(0.1),
                                          child: Hero(
                                            tag: music.id.toString(),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "$apiUrl/${music.cover}",
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    )),
                                SizedBox(
                                  width: getProportionateScreenWidth(10),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        music.title,
                                        maxLines: 1,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                getProportionateScreenHeight(
                                                    18)),
                                      ),
                                      Text(
                                        music.artist,
                                        maxLines: 1,
                                        style: const TextStyle(color: kGrey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            p.currentMusic == null
                                ? Container() :  !p.isMusicLoaded
                                &&  p.tIndex == musicIndex && favoriteMusics[p.tIndex].music.id== p.bufferingMusicId
                                ? SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: index.isEven ? kSecondaryColor : Colors.white,
                                  ),
                                );
                              },
                              size: 30,
                            )
                                : p.currentMusic!.title ==
                                        favoriteMusics[musicIndex].music.title && p.isMusicLoaded
                                    ? TrackMusicPlayButton(
                                        music: music,
                                        index: musicIndex,
                                        album: Album(
                                            id: -2,
                                            title: 'Favorite',
                                            artist: 'kin',
                                            description: '',
                                            cover: 'assets/images/kin.png',
                                            musics: favoriteMusicsList),
                                      )
                                    : Container(),
                          const  SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: kPrimaryColor,
                                        title: const Text(
                                          'Are Your Sure',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                'No',
                                                style: TextStyle(
                                                    color: kSecondaryColor),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                final provider = Provider.of<
                                                        FavoriteMusicProvider>(
                                                    context,
                                                    listen: false);
                                                provider.unMarkMusic(id);
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Yes',
                                                  style: TextStyle(
                                                      color: kSecondaryColor)))
                                        ],
                                      );
                                    });
                              },
                              child: SvgPicture.asset(
                                'assets/icons/favorite.svg',
                                height: getProportionateScreenHeight(30),
                                color: kSecondaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ));
        });
  }
}
