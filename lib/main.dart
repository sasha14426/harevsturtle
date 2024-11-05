import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hare_vs_turtle/game_screen.dart';
import 'package:hare_vs_turtle/leaderboard_screen.dart';
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
    final jsonData = await rootBundle.loadString(
        'assets/data/contestants_input.json');

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
              : LeaderboardScreen(
                  contest: contest,
                  showGame: showGame,
                  newContest: newContest,
                ),
        ),
      ),
    );
  }
}
