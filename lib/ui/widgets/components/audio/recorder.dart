import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hoshan/core/gen/assets.gen.dart';
import 'package:hoshan/core/services/permission/permission_service.dart';
import 'package:hoshan/ui/widgets/components/button/circle_icon_btn.dart';
import 'package:permission_handler/permission_handler.dart';

class Recorder extends StatefulWidget {
  final bool play;
  const Recorder({super.key, required this.play});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  @override
  void initState() {
    initRecorder();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future initRecorder() async {
    final status = await PermissionService.getPermission(
        permission: Permission.microphone);
    if (!status) {
      throw 'Permission Error';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
    if (widget.play) {
      await record();
    }
  }

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(
        toFile: '${DateTime.now().millisecondsSinceEpoch ~/ 1000}.wav');
  }

  Future recordStop() async {
    if (!isRecorderReady) return;

    final path = await recorder.stopRecorder();
    if (path == null) {
      throw 'record File Path Error';
    }
    final XFile file = XFile(path);
    print("filePath: ${file.path}");
  }

  void handleRecorder() async {
    if (recorder.isRecording) {
      await recordStop();
    } else {
      await record();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconBtn(
          icon: Assets.icon.outline.stop,
          onTap: handleRecorder,
        ),
        StreamBuilder<RecordingDisposition>(
          stream: recorder.onProgress,
          builder: (context, snapshot) {
            final duration =
                snapshot.hasData ? snapshot.data!.duration : Duration.zero;
            return Text('duration: ${duration.inSeconds} s');
          },
        )
      ],
    );
  }
}
