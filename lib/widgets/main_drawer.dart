import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  void onSelectScreenFromDrawer(BuildContext context, String pageIdentifier){
    Navigator.of(context).pop();
    onSelectScreen(pageIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.music_note,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text(
                  'Metronomy !',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.list,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'All songs',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
              ),
            ),
            onTap: () {
              onSelectScreenFromDrawer(context, 'all-songs');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.play_circle,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Play a song',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
              ),
            ),
            onTap: () {
              onSelectScreenFromDrawer(context, 'play-a-song');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.face,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Profil',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
              ),
            ),
            onTap: () {
              onSelectScreenFromDrawer(context, 'user-profil');
            },
          ),ListTile(
            leading: Icon(
              Icons.settings,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
              ),
            ),
            onTap: () {
              onSelectScreenFromDrawer(context, 'settings');
            },
          ),
        ],
      ),
    );
  }
}