import 'package:Metronomy/model/song.dart';
import 'package:flutter/material.dart';

class SongItem extends StatelessWidget {
  const SongItem({
    super.key,
    required this.song,
    required this.onSelectSong,
  });

  final Song song;

  final void Function(Song song) onSelectSong;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          onSelectSong(song);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              (song.title == "Billie Jean"
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Theme.of(context).colorScheme.primary,
              size: 24.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '${song.title}',
                    //overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                // Text(
                //   '${song.title}',
                //   //overflow: TextOverflow.ellipsis,
                //   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                //     color: Theme.of(context).colorScheme.primary,
                //   ),
                // ),
                Text('Auteur',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        )),
              ],
            ),
            Expanded(
              child: Container(
                //color: Colors.greenAccent,
                height: 50,
                width: 50,
              ),
            ),
            Column(
              children: [
                Text(
                  '${song.tempo} BPM',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                Text('${song.musiquePart.length} parties',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
