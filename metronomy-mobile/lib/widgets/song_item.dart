import 'package:flutter/material.dart';
import 'package:metronomy/model/song.dart';

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
            // FIXME : Implement favorite music selection
            // IconButton(
            //   icon: Icon(
            //     (song.title == "Billie Jean"
            //         ? Icons.favorite
            //         : Icons.favorite_border),
            //     color: Theme.of(context).colorScheme.primary,
            //     size: 24.0,
            //     semanticLabel: 'Text to announce in accessibility modes',
            //   ),
            //   tooltip: 'Select this song en go to play mode',
            //   onPressed: () {
            //     //widget.onSelectScreen('all-songs');
            //   },
            // ),
            // SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  //overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text('Auteur',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        )),
              ],
            ),
            const Expanded(
              child: SizedBox(
                height: 50,
                width: 50,
              ),
            ),
            Column(
              children: [
                Text(
                  '${song.tempo} BPM',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  // Very long text ...
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                Text('${song.musiquePart.length} parties',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
