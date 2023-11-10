import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerProvider extends InheritedWidget {
  static AudioPlayerProvider of(BuildContext context) {
    final AudioPlayerProvider? result =
    context.dependOnInheritedWidgetOfExactType<AudioPlayerProvider>();

    if (result == null) {
      throw 'No AudioPlayerProvider found';
    }

    return result;
  }

  static Future<AudioPlayer> createAudioPlayer() async {
    final audioPlayer = AudioPlayer()
      ..setPlayerMode(
        PlayerMode.lowLatency,
      );

    return audioPlayer;
  }

  final AudioPlayer audioPlayer;

  const AudioPlayerProvider({
    super.key,
    required super.child,
    required this.audioPlayer
  });

  @override
  bool updateShouldNotify(AudioPlayerProvider oldWidget) {
    return false;
  }
}