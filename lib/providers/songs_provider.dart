import 'dart:io';
import 'package:Metronomy/model/music_structure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Metronomy/model/song.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  SongsNotifier() : super(const []);

  Future<void> loadSongs() async {

    // load one song
    MusicStructure _musicStructureIntro = new MusicStructure(sectionName: "INTRO", sectionShortcut: "I", maximumBarsSection: 16, maximumBeatSection: 4);
    MusicStructure _musicStructureVerse = new MusicStructure(sectionName: "VERSE", sectionShortcut: "V", maximumBarsSection: 16, maximumBeatSection: 4);
    MusicStructure _musicStructureBreakdown = new MusicStructure(sectionName: "BREAKDOWN", sectionShortcut: "BD", maximumBarsSection: 8, maximumBeatSection: 4);
    MusicStructure _musicStructureBuildUp = new MusicStructure(sectionName: "BUILD UP", sectionShortcut: "BU", maximumBarsSection: 8, maximumBeatSection: 4);
    MusicStructure _musicStructureChorus = new MusicStructure(sectionName: "CHORUS", sectionShortcut: "C", maximumBarsSection: 16, maximumBeatSection: 4);
    MusicStructure _musicStructureOutro = new MusicStructure(sectionName: "OUTRO", sectionShortcut: "O", maximumBarsSection: 22, maximumBeatSection: 4);

    List<MusicStructure> myWaySteps =  <MusicStructure>[];
    myWaySteps.add(_musicStructureIntro);
    myWaySteps.add(_musicStructureVerse);
    myWaySteps.add(_musicStructureBreakdown);
    myWaySteps.add(_musicStructureBuildUp);
    myWaySteps.add(_musicStructureChorus);
    myWaySteps.add(_musicStructureOutro);

    Song myCurrentSong = new Song(title: "My Way", tempo: 222, musiquePart: myWaySteps);

    List<Song> allSongs = <Song>[myCurrentSong];

    state = allSongs;
  }
}

final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>(
      (ref) => SongsNotifier(),
);
