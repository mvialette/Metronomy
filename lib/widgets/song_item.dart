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
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectSong(song);
        },
        child: Text(
          song.title,
          maxLines: 2,
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis, // Very long text ...
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
