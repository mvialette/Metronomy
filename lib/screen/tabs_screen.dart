import 'package:Metronomy/model/song.dart';
import 'package:Metronomy/providers/songs_provider.dart';
import 'package:Metronomy/screen/music_player_screen.dart';
import 'package:Metronomy/screen/settings_screen.dart';
import 'package:Metronomy/screen/song_list_screen.dart';
import 'package:Metronomy/widgets/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  Widget? activePage;
  var activePageTitle = 'Metronomy';
  //TabsScreen

  @override
  void initState() {
    activePage = SettingsScreen();

    super.initState();
  }
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();

    if (identifier == 'all-songs') {
      setState(() {
        //final allAvailableSongs = ref.watch(songsProvider);
        /*
        CollectionReference songs = ref.read(songsProvider.notifier).loadSongs();

        List<Song> allAvailableSongs = <Song>[];
        songs.get().then((QuerySnapshot snapshot) {
          snapshot.docs.forEach((doc) {
            print('${doc.id} => ${doc.data()}');
            allAvailableSongs.add(Song.fromMap(doc.data() as Map<String, dynamic>));
          });
        }).catchError((error) => print("Failed to fetch users: $error"));
        */
        activePage = SongListScreen(title: 'List of songs',);
        //activePage = SongListScreen(songs: allAvailableSongs, title: 'List of songs',);
      });
    }else if (identifier == 'play-a-song') {
      setState(() {
        activePage = MusicPlayerScreen();
      });
    }else if (identifier == 'settings') {
      setState(() {
        activePage = SettingsScreen();

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(songsProvider);

    /*Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );*/
    /*Widget activePage = SongListScreen();
    var activePageTitle = 'Metronomy';*/
    


    /*if (_selectedPageIndex == 1) {
      final allAvailableSongs = ref.watch(songsProvider);
      activePage = SongListScreen(
        songs: allAvailableSongs,
      );
      activePageTitle = 'Your Favorites';
    }*/

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(children: [
            Icon(Icons.music_note),
            SizedBox(width: 15),
            Text('Metronomy')
          ]),
        ),
        drawer: MainDrawer(
          onSelectScreen: _setScreen,
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'All songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites songs',
          ),
        ],
      ),
    );
        /*
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SoundToggleButton(
              setStateCallback: () {
                setState(() {});
              },
            ),
            const SizedBox(width: 8.0),
            StopButton(
              setStateCallback: () {
                setState(() {});
              },
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          ],
        )
         */

  }
}
