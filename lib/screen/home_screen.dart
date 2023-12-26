import 'package:Metronomy/main.i18n.dart';
import 'package:Metronomy/screen/music_player_screen.dart';
import 'package:Metronomy/screen/settings_screen.dart';
import 'package:Metronomy/screen/song_list_screen.dart';
import 'package:Metronomy/screen/summary_song_screen.dart';
import 'package:Metronomy/screen/user_profil.dart';
import 'package:Metronomy/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  Widget? activePage;

  @override
  void initState() {
    _setScreen('all-songs');
    super.initState();
  }

  void _setScreen(String identifier) async {

    setState(() {
      if (identifier == 'all-songs') {
        activePage = SongListScreen(onSelectScreen: _setScreen,);
      } else if (identifier == 'play-a-song') {
        activePage = MusicPlayerScreen(onSelectScreen: _setScreen,);
      } else if (identifier == 'settings') {
        activePage = SettingsScreen();
      } else if (identifier == 'summary') {
        activePage = SummarySongScreen(onSelectScreen: _setScreen,);
      } else if (identifier == 'user-profil') {
        activePage = UserProfilScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(children: [
            Icon(Icons.music_note),
            SizedBox(width: 15),
            Text(appbarTitle.i18n),
          ]),
        ),
        drawer: MainDrawer(
          onSelectScreen: _setScreen,
        ),
        body: activePage,
    );
  }
}
