import 'dart:convert';
import 'dart:io';

import 'animal_info.dart';
import 'race.dart';

class Contest {
  final List<AnimalInfo> contestantsInfo;
  static const int numberOfRaces = 200;
  final Map<AnimalInfo, int> scores;
  final List<List<Map<AnimalInfo, int>>> raceDatas = [];
  final trackLength = 1000;

  Contest._(this.contestantsInfo)
      : scores = {for (var info in contestantsInfo) info: 0} {
    run();
  }

  factory Contest.fromFile(File file) {
    final List json = jsonDecode(file.readAsStringSync());
    final infos = json.map((json) => AnimalInfo.fromJson(json)).toList();
    return Contest._(infos);
  }

  factory Contest.fromJson(List json) => Contest._(json.map((json) => AnimalInfo.fromJson(json)).toList());

  void run() {
    for (var i = 0; i < numberOfRaces; i++) {
      final race = Race(contestantsInfo: contestantsInfo, trackLength: trackLength);
      race.run();

      for (var contestant in race.checkWinners()!) {
        scores[contestant.info] = scores[contestant.info]! + 1;
      }

      raceDatas.add(race.data);
    }
  }
}
