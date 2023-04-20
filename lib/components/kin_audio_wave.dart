import 'package:flutter/material.dart';

import '../constants.dart';
import '../size_config.dart';
import 'package:audio_wave/audio_wave.dart';


class KinPausedAudioWave extends StatelessWidget {

  const KinPausedAudioWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



  return AudioWave(

    animation: false,
    height: 25,
    width: 25,
    spacing: 1,
    alignment: 'bottom',

    beatRate: const Duration(milliseconds: 100),
    bars: [
      AudioWaveBar(

          heightFactor: 0.75, color: kSecondaryColor),
      AudioWaveBar(
          heightFactor: 0.5, color: Colors.white),
      AudioWaveBar(
          heightFactor: 0.25, color: kSecondaryColor),
      AudioWaveBar(
          heightFactor: 0.75, color: Colors.white),
      AudioWaveBar(
          heightFactor: 0.5, color: kSecondaryColor),
      AudioWaveBar(
          heightFactor: 0.25, color: Colors.white),
      AudioWaveBar(
          heightFactor: 0.75, color: kSecondaryColor),
      AudioWaveBar(
          heightFactor: 0.25, color: Colors.white),
      AudioWaveBar(
          heightFactor: 0.75, color: kSecondaryColor),
    ],
  );


  }
}

class KinPlayingAudioWave extends StatelessWidget {
  const KinPlayingAudioWave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AudioWave(

      animation: true,
      height: 25,
      width: 25,
      spacing: 1,
      alignment: 'bottom',

      beatRate: const Duration(milliseconds: 100),
      bars: [
        AudioWaveBar(

            heightFactor: 0.75, color: kSecondaryColor),
        AudioWaveBar(
            heightFactor: 0.5, color: Colors.white),
        AudioWaveBar(
            heightFactor: 0.25, color: kSecondaryColor),
        AudioWaveBar(
            heightFactor: 0.75, color: Colors.white),
        AudioWaveBar(
            heightFactor: 0.5, color: kSecondaryColor),
        AudioWaveBar(
            heightFactor: 0.25, color: Colors.white),
        AudioWaveBar(
            heightFactor: 0.75, color: kSecondaryColor),
        AudioWaveBar(
            heightFactor: 0.25, color: Colors.white),
        AudioWaveBar(
            heightFactor: 0.75, color: kSecondaryColor),
      ],
    );

  }
}
