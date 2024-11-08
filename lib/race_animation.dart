import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'animal_info.dart';
import 'contest.dart';

import 'pause_provider.dart';

class ContestAnimation extends FlameGame with RiverpodGameMixin {
  List<List<Map<AnimalInfo, int>>> get raceDatas => contest.raceDatas;
  final Contest contest;
  final void Function() onGameEnd;
  final frameRate = 100;

  ContestAnimation(this.contest, this.onGameEnd) {
    pauseWhenBackgrounded = false;
  }

  void _createRaceAnimation() async {
    for (var i = 0; i < raceDatas.length; i++) {
      final raceData = raceDatas[i];

      final raceContestantComponents = <SpriteComponent>[];

      for (var j = 0; j < contest.contestantsInfo.length; j++) {
        final ctnt = contest.contestantsInfo[j];
        // final ctntData = raceData.map((frameData) => frameData[ctnt]!).toList();

        raceContestantComponents.add(await _createContestant(
            Vector2(0, j * (size.y / contest.contestantsInfo.length)), ctnt.name));
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
            Duration(milliseconds: 1000 ~/ frameRate));
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

  Future<SpriteComponent> _createContestant(Vector2 startPosition, String contestantName) async {
    final sprite = await loadSprite('arrow.png');
    final dimention = size.y / contest.contestantsInfo.length;

    final label = TextComponent(position: Vector2(0, dimention/2), text: contestantName, anchor: Anchor.centerRight);

    startPosition.add(Vector2(0, dimention/2));

    final spriteComponent = SpriteComponent()
      ..sprite = sprite
      ..position = startPosition
      ..size = Vector2.all(dimention)
      ..anchor = Anchor.centerLeft;


    add(spriteComponent);

    spriteComponent.add(label);

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
