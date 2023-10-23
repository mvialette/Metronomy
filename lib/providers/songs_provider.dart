import 'package:Metronomy/model/music_structure.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:Metronomy/model/song.dart';

class SongsNotifier extends StateNotifier<List<Song>> {
  SongsNotifier() : super(const []);

  Future<void> loadSongs() async {

    //List<Song> allSongs = <Song>[];
    List<Song> allSongs = <Song>[getHereComesTheRainAgain()];

    state = allSongs;
  }

  Song getMyWay(){
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

    return new Song(title: "My Way", tempo: 222, musiquePart: myWaySteps);
  }

  // Here Comes The Rain Again
  Song getHereComesTheRainAgain(){

/*    Couplet : 8 mesures x2
    Refrain 16 mesures
    Couplet
    Refrain
    Pont : 8 mesures x 2
    Refrain
    Intro
    Couplet
    Couplet*/

    // load one song
    MusicStructure _musicStructureIntro = new MusicStructure(sectionName: "INTRO", sectionShortcut: "I", maximumBarsSection: 8, maximumBeatSection: 4);
    MusicStructure _musicStructureCouplet = new MusicStructure(sectionName: "COUPLET", sectionShortcut: "C", maximumBarsSection: 8, maximumBeatSection: 4);
    MusicStructure _musicStructureRefrain = new MusicStructure(sectionName: "REFRAIN", sectionShortcut: "R", maximumBarsSection: 16, maximumBeatSection: 4);
    MusicStructure _musicStructurePont = new MusicStructure(sectionName: "PONT", sectionShortcut: "P", maximumBarsSection: 8, maximumBeatSection: 4);

    List<MusicStructure> musicSteps =  <MusicStructure>[];
    musicSteps.add(_musicStructureIntro);
    musicSteps.add(_musicStructureIntro);
    musicSteps.add(_musicStructureCouplet);
    musicSteps.add(_musicStructureCouplet);
    musicSteps.add(_musicStructureRefrain);
    musicSteps.add(_musicStructureCouplet);
    musicSteps.add(_musicStructureRefrain);
    musicSteps.add(_musicStructurePont);
    musicSteps.add(_musicStructurePont);
    musicSteps.add(_musicStructureRefrain);
    musicSteps.add(_musicStructureIntro);
    musicSteps.add(_musicStructureIntro);
    musicSteps.add(_musicStructureCouplet);
    musicSteps.add(_musicStructureCouplet);

    return new Song(title: "Here comes the rain again", tempo: 115, musiquePart: musicSteps);
  }
}

final songsProvider = StateNotifierProvider<SongsNotifier, List<Song>>(
      (ref) => SongsNotifier(),
);
