import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kin_music_player_app/components/kin_audio_wave.dart';
import 'package:kin_music_player_app/services/network/model/music.dart';
import 'package:kin_music_player_app/services/network/model/album.dart';
import 'package:kin_music_player_app/services/network/model/podcast.dart';
import 'package:kin_music_player_app/services/network/model/podcastEpisode.dart';
import 'package:kin_music_player_app/services/provider/music_player.dart';
import 'package:kin_music_player_app/services/provider/podcast_player.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
class TrackMusicPlayButton extends StatelessWidget {
  final Function? onPressed;

  final Music? music;
  final Album? album;
  final int? index;

  TrackMusicPlayButton({this.onPressed, this.music, this.album, this.index});

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<MusicPlayer>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return SizedBox(

            height: 25,
            width: 25,
            child: !p.isMusicLoaded
                && p.tIndex == index && album!.musics[p.tIndex].id == p.bufferingMusicId
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
                :   p.isMusicInProgress(music!)
                ? const KinPlayingAudioWave() : const KinPausedAudioWave()
          );
        });
  }
}


class TrackEpisodePlayButton extends StatelessWidget {
  final Function? onPressed;

  final PodCast? podCast;
  final PodCastEpisode? episode;
  final int? index;

  TrackEpisodePlayButton({this.onPressed, this.episode, this.podCast, this.index});

  @override
  Widget build(BuildContext context) {
    var p = Provider.of<PodcastPlayer>(context, listen: false);

    return PlayerBuilder.isPlaying(
        player: p.player,
        builder: (context, isPlaying) {
          return SizedBox(

              height: 25,
              width: 25,
              child: !p.isEpisodeLoaded
              && p.tIndex == index && podCast!.episodes[p.tIndex].id == p.bufferingEpisodeId
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
                  :   p.isEpisodeInProgress(episode!) ? const KinPlayingAudioWave() : const KinPausedAudioWave()
          );
        });
  }
}
