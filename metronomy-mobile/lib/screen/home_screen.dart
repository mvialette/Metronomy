import 'package:metronomy/screen/login_screen.dart';
import 'package:metronomy/screen/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:metronomy/screen/music_player_screen.dart';
import 'package:metronomy/screen/settings_screen.dart';
import 'package:metronomy/screen/song_list_screen.dart';
import 'package:metronomy/screen/summary_song_screen.dart';
import 'package:metronomy/screen/user_profil.dart';
import 'package:metronomy/widgets/main_drawer.dart';
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
        activePage = SongListScreen(
          onSelectScreen: _setScreen,
        );
      } else if (identifier == 'login') {
        activePage = const LoginScreen();
      } else if (identifier == 'splash') {
        activePage = const SplashScreen();
      } else if (identifier == 'play-a-song') {
        activePage = MusicPlayerScreen(
          onSelectScreen: _setScreen,
        );
      } else if (identifier == 'settings') {
        activePage = const SettingsScreen();
      } else if (identifier == 'summary') {
        activePage = SummarySongScreen(
          onSelectScreen: _setScreen,
        );
      } else if (identifier == 'user-profil') {
        activePage = const UserProfilScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          AppLocalizations.of(context)!.applicationTitle,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/MotifsNoirs.png"),
            colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.background.withOpacity(0.1),
                BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child: activePage,
      ),
    );
  }
}
