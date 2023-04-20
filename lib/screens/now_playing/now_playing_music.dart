import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/components/animation_rotate.dart';
import 'package:kin_music_player_app/components/position_seek_widget.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';
import 'package:kin_music_player_app/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/favorite_music_provider.dart';
import 'package:flutter_html/flutter_html.dart';

class NowPlayingMusic extends StatefulWidget {
  static const String routeName = '/nowPlaying';
  final Music? musicForId;

  NowPlayingMusic(this.musicForId);

  @override
  State<NowPlayingMusic> createState() => _NowPlayingMusicState();
}

class _NowPlayingMusicState extends State<NowPlayingMusic> {
  late int musicId;

  @override
  void initState() {
    // TODO: implement initState
    musicId = widget.musicForId!.id;
    Provider.of<FavoriteMusicProvider>(context, listen: false)
        .isMusicFav(musicId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Music? music;
    musicId = music?.id ?? widget.musicForId!.id;
    var playerProvider = Provider.of<MusicPlayer>(context);
    playerProvider.audioSessionListener();

    return Scaffold(
        backgroundColor: kPrimaryColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Now Playing',
            style: TextStyle(color: kSecondaryColor),
          ),
          leading: BackButton(
            color: kSecondaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 2,
          backgroundColor: Colors.transparent,
        ),
        body: PlayerBuilder.realtimePlayingInfos(
          player: playerProvider.player,
          builder: (context, info) {
            music = playerProvider.currentMusic;

            if (info.playingPercent == 0.0) {
              Provider.of<FavoriteMusicProvider>(context, listen: false)
                  .isMusicFav(music!.id);
            }
            return Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          CachedNetworkImageProvider('$apiUrl/${music!.cover}'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  color: kPrimaryColor.withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: getProportionateScreenHeight(5),
                      ),
                      _buildAlbumCover(
                        playerProvider,
                        music!,
                      ),
                      _buildSongTitle(music),
                      SizedBox(
                        height: getProportionateScreenHeight(25),
                      ),
                      _buildProgressBar(info, music!, playerProvider),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildRepeatButton(playerProvider),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          _buildPreviousButton(playerProvider),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          _buildPlayPauseButton(playerProvider),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          _buildNextButton(playerProvider),
                          SizedBox(
                            width: getProportionateScreenWidth(5),
                          ),
                          _buildShuffleButton(playerProvider)
                        ],
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(15),
                      ),
                      music!.lyrics!.isNotEmpty
                          ? _buildScrollableLyrics(context, music!.lyrics)
                          : Container(),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget _buildAlbumCover(
    MusicPlayer playerProvider,
    Music music,
  ) {
    return Container(
        height: 250,
        margin: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(30),
            horizontal: getProportionateScreenWidth(30)),
        child: AnimationRotate(
          stop: !playerProvider.isPlaying(),
          child: SizedBox(
            height: 250,
            width: 250,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: playerProvider.getMusicCover(),
                      height: 250,
                      width: 250,
                    ),
                    Container(
                      height: 250,
                      width: 250,
                      decoration: BoxDecoration(
                        //  borderRadius: BorderRadius.circular(1000),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF343434).withOpacity(0.4),
                            const Color(0xFF343434).withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      '$apiUrl/${music.cover}'),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                              ),
                            ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      '$apiUrl/${music.cover}'),
                                  fit: BoxFit.cover)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 75, sigmaY: 75),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1000),
                                ),
                              ),
                            ),
                          )),
                    ),
                  ],
                )),
          ),
        ));
  }

  Widget _buildProgressBar(
      RealtimePlayingInfos info, Music music, MusicPlayer playerProvider) {
    return PositionSeekWidget(
      currentPosition: info.currentPosition,
      duration: //just a dummy time if stream
          info.duration,
      seekTo: (to) {
        playerProvider.player.seek(to);
      },
    );
  }

  Widget _buildSongTitle(Music? music) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                music!.title,
                style: const TextStyle(
                    color: kSecondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              Consumer<FavoriteMusicProvider>(
                builder: (context, provider, _) {
                  return provider.isFavorite == 1
                      ? IconButton(
                          onPressed: () {
                            provider.unFavMusic(musicId);
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: kSecondaryColor,
                          ))
                      : IconButton(
                          onPressed: () {
                            provider.favMusic(musicId);
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            color: kSecondaryColor,
                          ));
                },
              )
            ],
          ),
          Text(
            music.artist,
            style: const TextStyle(color: kGrey, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildRepeatButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: Icon(!playerProvider.loopPlaylist && playerProvider.loopMode
          ? Icons.repeat_one
          : Icons.repeat),
      color: playerProvider.loopMode ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleLoop(),
    );
  }

  Widget _buildPreviousButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(Icons.skip_previous),
      color: playerProvider.isFirstMusic() ? kGrey : Colors.white,
      onPressed: () {
        playerProvider.prev();
      },
    );
  }

  Widget _buildPlayPauseButton(MusicPlayer playerProvider,) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
        player: playerProvider.player,
        builder: (context, isPlaying) {
          return InkWell(
            onTap: () {
              if (isPlaying || playerProvider.player.isBuffering.value) {
                playerProvider.player.pause();
              } else {
                if (checkConnection(status)) {
                  playerProvider.player.play();

                } else {
                  kShowToast();
                }
              }
            },
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kSecondaryColor, kPrimaryColor.withOpacity(0.75)],
                  ),
                  borderRadius: BorderRadius.circular(1000)),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 15,
                child: !playerProvider.isMusicLoaded
                    ? SpinKitFadingCircle(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color:
                                  index.isEven ? kSecondaryColor : Colors.white,
                            ),
                          );
                        },
                        size: 30,
                      )
                    : SvgPicture.asset(
                        isPlaying
                            ? 'assets/icons/pause.svg'
                            : 'assets/icons/play-triangle.svg',
                        fit: BoxFit.contain,
                        color: Colors.white,
                      ),
              ),
            ),
          );
        });
  }

  Widget _buildNextButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(Icons.skip_next),
      color: playerProvider.isLastMusic(playerProvider.currentIndex! + 1)
          ? kGrey
          : Colors.white,
      onPressed: () {
        if (playerProvider.isLastMusic(playerProvider.currentIndex! + 1)) {
          return;
        }
        playerProvider.next();
      },
    );
  }

  Widget _buildShuffleButton(MusicPlayer playerProvider) {
    return IconButton(
      icon: const Icon(Icons.shuffle),
      color: playerProvider.shuffled ? Colors.white : kGrey,
      onPressed: () => playerProvider.handleShuffle(),
    );
  }

  Widget _buildScrollableLyrics(BuildContext context, lyrics) {
    return GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onVerticalDragStart: (DragStartDetails dragStartDetails) {
        showMaterialModalBottomSheet(
          context: context,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: double.infinity,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: kGrey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                      top: getProportionateScreenHeight(50),
                      left: getProportionateScreenWidth(100)),
                  child: SizedBox(
                      width: double.infinity,
                      child: Html(
                        data: lyrics,
                        style: {
                          'p': Style(
                              color: Colors.white,
                              fontFamily: 'Nokia',
                              lineHeight: LineHeight.number(2))
                        },
                      )),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: kGrey.withOpacity(0.15),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Icon(
              Icons.expand_less,
              color: kSecondaryColor,
            ),
            Center(
              child: Text(
                'Lyrics',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
