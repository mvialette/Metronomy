import 'package:Metronomy/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  void onSelectScreenFromDrawer(BuildContext context, String pageIdentifier) {
    Navigator.of(context).pop();
    onSelectScreen(pageIdentifier);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        child: ListView(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                //color: Theme.of(context).colorScheme.background,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.background,
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
                  const Image(
                    image:
                        AssetImage("assets/images/metronomy_icon_yellow.png"),
                    width: 40,
                  ),
                  const SizedBox(width: 18),
                  Text(
                    AppLocalizations.of(context)!.applicationTitle,
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.allSongs,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.playASong,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
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
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.profil,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                onSelectScreenFromDrawer(context, 'user-profil');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                size: 26,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                onSelectScreenFromDrawer(context, 'settings');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                size: 26,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: Text(
                AppLocalizations.of(context)!.logout,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24,
                    ),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
