import 'package:flutter/material.dart';
import 'package:hare_vs_turtle/animal_info.dart';
import 'package:hare_vs_turtle/contest.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({
    super.key,
    required this.contest, required this.sorter,
  });

  final int Function(AnimalInfo, AnimalInfo) sorter;
  final Contest? contest;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contest!.contestantsInfo.length,
      itemBuilder: (context, index) {
        final List<AnimalInfo> infos =
            List.from(contest!.contestantsInfo);
        infos.sort(sorter);
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
    );
  }
}
