// lib/constants.dart
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// représente le rythme du métronome par défaut quand on arrive dans l'application
const kDefaultRhythm = 120;

// représente l'état d'activié du métronome par défaut quand on arrive dans l'application
const kDefaultEnable = false;

// valeur par defaut pour le timer de debug (surchargé lors du chargement d'une musique)
const kDefaultStartingCountdown = 10;

// Nombre de mesure par défaut pour la période de startup
const kDefaultStartingBarsNumber = 2;

// rythme minimum du métronome
const kMinRhythm = 30;

// rythme maximum du métronome
const kMaxRhythm = 220;

// icône du bouton "lecture"
const kPlayIcon = Icons.play_arrow;

// icône du bouton "pause"
const kPauseIcon = Icons.pause;

final songHigh = AssetSource('song-high.mpeg');
final songLow = AssetSource('song-low.mpeg');

final kSelectedCollection = "songs_202312132100";