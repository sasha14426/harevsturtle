import 'package:flutter/material.dart';
import 'package:hare_vs_turtle/contest.dart';
import 'package:hare_vs_turtle/leaderboard.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({
    super.key,
    required this.contest,
    required this.showGame,
    required this.newContest,
  });

  final Contest? contest;
  final Function() showGame;
  final Function() newContest;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    sorter: (a, b) =>
                        contest!.scores[b]!.compareTo(contest!.scores[a]!),
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
              onPressed: newContest,
              child: const Text('New contest'),
            ),
          ],
        ),
      ],
    );
  }
}
