// lib/constants.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// représente le rythme du métronome par défaut quand on arrive dans l'application
const kDefaultRhythm = 120;

// représente l'état d'activié du métronome par défaut quand on arrive dans l'application
const kDefaultEnable = false;

const kDefaultStartingCountdown = 10;

// rythme minimum du métronome
const kMinRhythm = 30;

// rythme maximum du métronome
const kMaxRhythm = 220;

// icône du bouton "lecture"
const kPlayIcon = Icons.play_arrow;

// icône du bouton "pause"
const kPauseIcon = Icons.pause;

final soundSource = AssetSource('metronome-sound.mp3');
final songFirst = AssetSource('metronomy-song-first.mp3');
final songNext = AssetSource('metronome-song.mp3');
//
//final songA = AssetSource('start-13691.mp3');
/*final songA = AssetSource('metronome-song.mp3');
final songB = AssetSource('metronome-85688.mp3');*/

final songA = AssetSource('song-a.mpeg');
final songB = AssetSource('song-b.mpeg');