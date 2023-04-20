import 'dart:ui';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kin_music_player_app/screens/now_playing/now_playing_music.dart';
import 'package:kin_music_player_app/services/connectivity_result.dart';
import 'package:provider/provider.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';

import '../constants.dart';
import '../size_config.dart';

class NowPlayingMusicIndicator extends StatefulWidget {
  @override
  State<NowPlayingMusicIndicator> createState() =>
      _NowPlayingMusicIndicatorState();
}

class _NowPlayingMusicIndicatorState extends State<NowPlayingMusicIndicator> {
   double minPlayerHeight = 70;


  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return SizedBox(
            height: minPlayerHeight,
            width: double.infinity,
            child: Stack(
              children: [
                _buildBlurBackground(p.getMusicCover()),
                _buildDarkContainer(),
                Container(
                  height: 70,
                  color: Colors.transparent,
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                      getProportionateScreenWidth(20),
                      getProportionateScreenHeight(10),
                      getProportionateScreenWidth(30),
                      getProportionateScreenHeight(10)),
                  child: GestureDetector(
                    onTap: () {

                      p.setBuffering(p.tIndex,p.currentMusic!.id);
                      p.isMusicInProgress(p.currentMusic!)
                          ? Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NowPlayingMusic(p.currentMusic)))
                          : p.handlePlayButton(
                              music: p.currentMusic!,
                              index: p.tIndex,
                              album: p.currentAlbum,
                            );

                    },
                    child: Row(
                      children: [
                        _buildCover(p),
                        SizedBox(
                          width: getProportionateScreenWidth(10),
                        ),
                        _buildTitleAndArtist(
                            p.currentMusic!.title, p.currentMusic!.artist),
                        Row(
                          children: [
                            _buildPreviousButton(p),
                            _buildPlayPauseButton(
                              p,
                            ),
                            _buildNextButton(p)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCloseButton(p),
              ],
            ),
          );
        });
  }

  Widget _buildBlurBackground(musicCover) {
    return ClipRect(
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
          image: DecorationImage(
              image: CachedNetworkImageProvider(musicCover), fit: BoxFit.cover),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: const SizedBox(
            height: 70,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDarkContainer() {
    return Container(
      height: 70,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            kPrimaryColor.withOpacity(0.75),
            kPrimaryColor.withOpacity(0.75),
          ],
        ),
      ),
    );
  }

  Widget _buildCover(provider) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: AspectRatio(
          aspectRatio: 1.02,
          child: Container(
              color: kSecondaryColor.withOpacity(0.1),
              child: Hero(
                tag: 'now playing',
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '$apiUrl/${provider.currentMusic.cover}',
                ),
              )),
        ));
  }

  Widget _buildTitleAndArtist(musicTitle, musicCover) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            musicTitle,
            softWrap: false,
            maxLines: 1,
            style: const TextStyle(color: kSecondaryColor, fontSize: 16),
          ),
          Text(
            musicCover,
            maxLines: 1,
            softWrap: false,
            style: const TextStyle(color: kGrey),
          ),
        ],
      ),
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
  Widget _buildPlayPauseButton(MusicPlayer playerProvider) {
    ConnectivityStatus status = Provider.of<ConnectivityStatus>(context);

    return PlayerBuilder.isPlaying(
        player: playerProvider.player,
        builder: (context, isPlaying) {
          return InkWell(
            onTap: () {
          if(isPlaying || playerProvider.player.isBuffering.value){
            playerProvider.player.pause();
          }else{
            if(checkConnection(status)){
              playerProvider.player.play();
            }else{
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
                child: SvgPicture.asset(
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

  Widget _buildCloseButton(MusicPlayer provider) {
    return Positioned(
      top: -10,
      right: -10,
      child: IconButton(
          onPressed: () async {
            provider.player.stop();
            provider.setMusicStopped(true);

            setState(() {
              minPlayerHeight = 0;
            });
          },
          icon: const Icon(
            Icons.clear,
            color: kGrey,
            size: 20,
          )),
    );
  }

}
