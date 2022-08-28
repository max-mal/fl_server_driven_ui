import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String path;
  const AudioPlayerWidget({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerWidget> {
  final player = AudioPlayer();
  Rx<Duration> rxPosition = Rx<Duration>(const Duration());
  RxBool playing = false.obs;

  late StreamSubscription<Duration> positionStream;
  late StreamSubscription<PlayerState> playerStateStream;

  @override
  void initState() {
    player.setUrl(widget.path);
    positionStream = player.positionStream.listen((event) {
      rxPosition(player.position);
    });
    playerStateStream = player.playerStateStream.listen((event) {
      playing(event.playing);
    });
    super.initState();
  }

  @override
  void dispose() {
    positionStream.cancel();
    playerStateStream.cancel();
    player.stop().then((value) => player.dispose());

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Obx(
            () => playing.value
                ? IconButton(
                    onPressed: () {
                      player.pause();
                    },
                    icon: const Icon(Icons.pause),
                  )
                : IconButton(
                    onPressed: () {
                      player.play();
                    },
                    icon: const Icon(Icons.play_arrow),
                  ),
          ),
          Expanded(
            child: Obx(
              () => Slider(
                value: rxPosition.value.inMicroseconds.toDouble(),
                max: (player.duration ?? rxPosition.value)
                    .inMicroseconds
                    .toDouble(),
                onChanged: (value) {
                  player.seek(Duration(microseconds: value.toInt()));
                },
              ),
            ),
          ),
          Obx(
            () => Text(
              "${rxPosition.value.inSeconds} / ${(player.duration ?? rxPosition.value).inSeconds}",
            ),
          ),
        ],
      ),
    );
  }
}
