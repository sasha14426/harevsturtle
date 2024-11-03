import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:ht/animal_info.dart';
import 'package:ht/contest.dart';

import 'pause_provider.dart';

class ContestAnimation extends FlameGame with RiverpodGameMixin {
  List<List<Map<AnimalInfo, int>>> get raceDatas => contest.raceDatas;
  final Contest contest;
  final void Function() onGameEnd;
  final frameRate = 100000;

  ContestAnimation(this.contest, this.onGameEnd) {
    pauseWhenBackgrounded = false;
  }

  void _createRaceAnimation() async {
    for (var i = 0; i < raceDatas.length; i++) {
      final raceData = raceDatas[i];

      final raceContestantComponents = <SpriteComponent>[];

      for (var j = 0; j < contest.contestantsInfo.length; j++) {
        // final ctnt = contest.contestantsInfo[j];
        // final ctntData = raceData.map((frameData) => frameData[ctnt]!).toList();

        raceContestantComponents.add(await _createContestant(
            Vector2(0, j * (size.y / contest.contestantsInfo.length))));
      }

      for (var j = 0; j < raceData.length; j++) {
        await _pauseCheck();
        for (var k = 0; k < contest.contestantsInfo.length; k++) {
          final ctnt = contest.contestantsInfo[k];
          final ctntData = raceData[j][ctnt]!;
          final spriteComponent = raceContestantComponents[k];
          spriteComponent.position.x =
              (ctntData / contest.trackLength) * size.x;
        }

        await Future.delayed(
            Duration(milliseconds: (1000 / frameRate).toInt()));
      }

      // ref.read(pauseProvider.notifier).setState(true);
      // paused = true;
      await _pauseCheck();
      removeAll(raceContestantComponents);
    }

    onGameEnd();
  }

  Future<void> _pauseCheck() async {
    while (paused) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  Future<SpriteComponent> _createContestant(Vector2 startPosition) async {
    final sprite = await loadSprite('adrian.jpg');
    final dimention = size.y / contest.contestantsInfo.length;

    final spriteComponent = SpriteComponent()
      ..sprite = sprite
      ..position = startPosition
      ..size = Vector2.all(dimention);

    add(spriteComponent);
    return spriteComponent;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _createRaceAnimation();
  }

  @override
  void onMount() {
    super.onMount();
    paused = ref.watch(pauseProvider);
  }
}
