import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:provider/provider.dart';
import 'game.dart';

import '../models/settings.dart';

class AudioPlayerComponent extends Component with HasGameRef<MasksweirdGame> {
  AudioPlayer audio = AudioPlayer();
  @override
  Future<void>? onLoad() async {
    FlameAudio.bgm.initialize();
    await FlameAudio.audioCache.load('music.mp3');
    await audio.audioCache.loadAll([
      // 'audio/game_over.mp3',
      'audio/crack.wav',
    ]);
    return super.onLoad();
  }

  void playBgm(String filename) {
    if (!FlameAudio.audioCache.loadedFiles.containsKey(filename)) return;

    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .backgroundMusic) {
        FlameAudio.bgm.play(filename);
      }
    }
  }

  void playSfx(String filename) async {
    if (gameRef.buildContext != null) {
      if (Provider.of<Settings>(gameRef.buildContext!, listen: false)
          .soundEffects) {
        await audio.play(AssetSource(filename));
      }
    }
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }
}
