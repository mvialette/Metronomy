
import 'package:flutter/material.dart';

class SongTitleWidget extends StatelessWidget{
  const SongTitleWidget({
    super.key, required this.songName
});
  final String songName;


  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Titre : ',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          '${songName}',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.normal,
              color: Colors.orange
          ),
        ),
      ],
    );

  }
}