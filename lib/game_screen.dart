import 'package:flame/game.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hare_vs_turtle/pause_provider.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({
    super.key,
    required Game? game,
  }) : _game = game;

  final Game? _game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = ref.watch(pauseProvider);
    return Column(
        children: [
          Expanded(
              child: RiverpodAwareGameWidget(
            key: GlobalKey<RiverpodAwareGameWidgetState>(),
            game: _game!,
          )),
          IconButton(
            onPressed: () =>
                ref.read(pauseProvider.notifier).toggle(),
            icon: isPaused
                ? const Icon(Icons.play_arrow)
                : const Icon(Icons.pause),
          ),
        ],
      );
  }
}
