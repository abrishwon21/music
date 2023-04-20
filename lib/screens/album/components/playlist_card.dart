import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/components/kin_audio_wave.dart';
import 'package:kin_music_player_app/components/kin_progress_indicator.dart';
import 'package:kin_music_player_app/components/track_play_button.dart';

import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/playlist_titles.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/playlist_provider.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:kin_music_player_app/services/provider/radio_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../services/connectivity_result.dart';
import '../../../size_config.dart';
import '../../radio.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    Key? key,
    required this.album,
    this.musicIndex = -1,
    this.height = 70,
    this.aspectRatio = 1.02,
    required this.music,
  }) : super(key: key);

  final double height, aspectRatio;
  final Music music;
  final int musicIndex;
  final Album album;

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(
      context,
    );
    var provider = Provider.of<PlayListProvider>(
      context,
    );
    var podcastProvider = Provider.of<PodcastPlayer>(
      context,
    );
    var radioProvider = Provider.of<RadioProvider>(
      context,
    );
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);
    return PlayerBuilder.isPlaying(
      player: p.player,
      builder: (context, isPlaying) {
        return Container(
            height: getProportionateScreenHeight(height),
            margin: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20),
                vertical: getProportionateScreenHeight(10)),
            child: InkWell(
              onTap: () {
                p.setBuffering(musicIndex,music.id);

                if (checkConnection(status)) {

                  if (p.isMusicInProgress(music)) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NowPlayingMusic(music)));
                  } else {
                    radioProvider.player.stop();
                    podcastProvider.player.stop();
                    p.player.stop();

                    p.setMusicStopped(true);
                    podcastProvider.setEpisodeStopped(true);
                    p.listenMusicStreaming();
                    podcastProvider.listenPodcastStreaming();

                    p.setPlayer(p.player, podcastProvider, radioProvider);
                    p.handlePlayButton(
                      music: music,
                      index: musicIndex,
                      album: album,
                    );
                  }

                  p.setMusicStopped(false);
                  podcastProvider.setEpisodeStopped(true);
                  p.listenMusicStreaming();
                  podcastProvider.listenPodcastStreaming();
                }else{
                  kShowToast();
                }
              },
              child: Hero(
                tag: music.title,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1.02,
                          child: Container(
                              color: kSecondaryColor.withOpacity(0.1),
                              child: CachedNetworkImage(
                                imageUrl: '$apiUrl/${music.cover}',
                                fit: BoxFit.cover,
                              )),
                        )),
                    SizedBox(
                      width: getProportionateScreenWidth(10),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            music.title,
                            style: const TextStyle(
                                color: kSecondaryColor, fontSize: 16,fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  music.artist,
                                  style: const TextStyle(color: kGrey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              p.currentMusic == null
                                  ? Container()
                                  :  !p.isMusicLoaded
                                  &&  p.tIndex == musicIndex && album.musics[p.tIndex].id == p.bufferingMusicId
                                  ? SpinKitFadingCircle(
                                itemBuilder: (BuildContext context, int index) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: index.isEven ? kSecondaryColor : Colors.white,
                                    ),
                                  );
                                },
                                size: 30,
                              ):  p.currentMusic!.id ==
                                          album.musics[musicIndex].id && p.isMusicLoaded
                                      ? TrackMusicPlayButton(
                                          music: music,
                                          index: musicIndex,
                                          album: album,
                                        )
                                      : Container()
                            ],
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton(
                      initialValue: 0,
                      child: const Icon(
                        Icons.more_vert,
                        color: kSecondaryColor,
                      ),
                      onSelected: (value) {
                        if (value == 2) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: kPrimaryColor,
                                  title: const Text(
                                    'Music Detail',
                                    style: TextStyle(
                                        color: Colors.white60, fontSize: 15),
                                  ),
                                  content: SizedBox(
                                    height: 100,
                                    child: Column(
                                      children: [
                                        Text(
                                          music.description,
                                          style: const TextStyle(
                                              color: kLightSecondaryColor),
                                        ),
                                        Text('By ${music.artist}',
                                            style: const TextStyle(
                                                color: kLightSecondaryColor))
                                      ],
                                    ),
                                  ),
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: kPrimaryColor,
                                  title: const Text(
                                    'Choose Playlist',
                                    style: TextStyle(color: kGrey),
                                  ),
                                  content: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: FutureBuilder<List<PlayListTitles>>(
                                      future: provider.getPlayListTitle(),
                                      builder: (context,
                                          AsyncSnapshot<List<PlayListTitles>>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder: (context, index) {
                                              return Consumer<PlayListProvider>(
                                                builder: (BuildContext context,
                                                    provider, _) {
                                                  return TextButton(
                                                      onPressed: () async {
                                                        var playlistInfo = {
                                                          'playListTitleId':
                                                              snapshot
                                                                  .data![index]
                                                                  .id,
                                                          'musicId': music.id
                                                        };
                                                        var result = await provider
                                                            .addMusicToPlaylist(
                                                                playlistInfo);

                                                        if (result) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Successfully added')));
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Music Already added')));
                                                        }
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text(
                                                        snapshot
                                                            .data![index].title,
                                                        style: const TextStyle(
                                                            color:
                                                                kLightSecondaryColor),
                                                      ));
                                                },
                                              );
                                            },
                                            shrinkWrap: true,
                                          );
                                        }
                                        return Center(
                                          child: KinProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      itemBuilder: (context) {
                        return kMusicPopupMenuItem;
                      },
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
