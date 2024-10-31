import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';

class Player extends StatefulWidget {
  const Player({super.key});

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen(
      (state) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      },
    );

    audioPlayer.onDurationChanged.listen(
      (newDuration) {
        setState(() {
          duration = newDuration;
        });
      },
    );

    audioPlayer.onPositionChanged.listen(
      (newPosition) {
        setState(() {
          position = newPosition;
        });
      },
    );
  }

  Future setAudio() async {
    audioPlayer.setReleaseMode(ReleaseMode.stop);
    // audioPlayer.setSource(DeviceFileSource(path));
    audioPlayer.setSource(UrlSource(
        'https://ts2.tarafdari.com/contents/user6984/content-sound/17_-_without_me.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value) async {
            final position = Duration(seconds: value.toInt());
            await audioPlayer.seek(position);
            // await audioPlayer.resume();
          },
        ),
        Row(
          children: [
            Text('position: ${position.inSeconds}'),
            Text('duration: ${duration.inSeconds}'),
          ],
        ),
        CircleIconBtn(
          icon:
              isPlaying ? Assets.icon.outline.pause : Assets.icon.outline.play,
          size: 50,
          onTap: () async {
            if (isPlaying) {
              await audioPlayer.pause();
            } else {
              await audioPlayer.resume();
            }
          },
        )
      ],
    );
  }
}
