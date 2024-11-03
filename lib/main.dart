import 'dart:io';

import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'race_animation.dart';

import 'animal_info.dart';
import 'contest.dart';
import 'package:flame/game.dart';

import 'pause_provider.dart';

void main() {
  runApp(const ProviderScope(
    child: MaterialApp(
      home: MyApp(),
    ),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Game? _game;
  Contest? contest;
  bool _gameIsShowing = false;

  void _newContest() {
    final file =
        File('contestants_input.json'); // Make sure this path is correct
    contest = Contest.fromFile(file);

    _game = ContestAnimation(contest!, _onGameEnd);

    setState(() {
      _gameIsShowing = true;
    });
  }

  void _onGameEnd() {
    setState(() {
      _gameIsShowing = false;
    });
  }

  void _showGame() {
    if (_game != null) {
      setState(() {
        _gameIsShowing = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPaused = ref.watch(pauseProvider);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: _gameIsShowing
              ? Column(
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
                )
              : Column(
                  children: [
                    if (contest != null)
                      const Text(
                        "Last contest's Scores:",
                        style: TextStyle(fontSize: 25),
                      ),
                    if (contest != null)
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: contest!.contestantsInfo.length,
                                itemBuilder: (context, index) {
                                  final List<AnimalInfo> infos =
                                      List.from(contest!.contestantsInfo);
                                  infos.sort((a, b) => contest!.scores[b]!
                                      .compareTo(contest!.scores[a]!));
                                  final ctnt = infos[index];

                                  return Card(
                                    margin: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "$ctnt's score is ${contest!.scores[ctnt]}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: contest!.contestantsInfo.length,
                                itemBuilder: (context, index) {
                                  final List<AnimalInfo> infos =
                                      List.from(contest!.contestantsInfo);
                                  infos.sort((a, b) => a.name.compareTo(b.name));
                                  final ctnt = infos[index];
                                  return Card(
                                    margin: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text(
                                        "$ctnt's score is ${contest!.scores[ctnt]}",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (contest != null)
                          TextButton(
                            onPressed: _showGame,
                            child: const Text('Replay last contest'),
                          ),
                        TextButton(
                          onPressed: () => setState(() {
                            _newContest();
                          }),
                          child: const Text('New contest'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
