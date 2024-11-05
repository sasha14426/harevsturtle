import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hare_vs_turtle/game_screen.dart';
import 'package:hare_vs_turtle/leaderboard.dart';
import 'race_animation.dart';

import 'contest.dart';
import 'package:flame/game.dart';

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

  void newContest() async {
    // final file =
    //     File('lib/contestants_input.json'); // Make sure this path is correct
    // contest = Contest.fromFile(file);

    final jsonData = await rootBundle.loadString(
        'assets/data/contestants_input.json'); // TODO Ensure that the await doesn't cause issues

    contest = Contest.fromJson(jsonDecode(jsonData));

    _game = ContestAnimation(contest!, onGameEnd);

    setState(() {
      _gameIsShowing = true;
    });
  }

  void onGameEnd() {
    setState(() {
      _gameIsShowing = false;
    });
  }

  void showGame() {
    if (_game != null) {
      setState(() {
        _gameIsShowing = true;
        _game?.onLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(100.0),
          child: _gameIsShowing
              ? GameScreen(game: _game)
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
                              child: Leaderboard(
                                contest: contest,
                                sorter: (a, b) => contest!.scores[b]!
                                    .compareTo(contest!.scores[a]!),
                              ),
                            ),
                            Expanded(
                              child: Leaderboard(
                                contest: contest,
                                sorter: (a, b) => a.name.compareTo(b.name),
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
                            onPressed: showGame,
                            child: const Text('Replay last contest'),
                          ),
                        TextButton(
                          onPressed: () => setState(() {
                            newContest();
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
