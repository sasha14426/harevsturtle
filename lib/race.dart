import 'animal.dart';
import 'animal_info.dart';

class Race {
  final List<Animal> contestants;
  final int trackLength;
  List<Map<AnimalInfo, int>> data = [];

  Race({required this.trackLength, required List<AnimalInfo> contestantsInfo})
      : contestants =
            contestantsInfo.map((AnimalInfo info) => Animal(info)).toList();

  List<Animal>? checkWinners() {
    final winners =
        contestants.where((animal) => animal.distance >= trackLength).toList();
    return winners.isNotEmpty ? winners : null;
  }

  void step() {
    final Map<AnimalInfo, int> frameData = {};
    for (var animal in contestants) {
      animal.move();
      frameData[animal.info] = animal.distance;
    }

    data.add(frameData);
  }

  void run() {
    while (checkWinners() == null) {
      step();
    }
    // print(data);
    // print('Winners: ${checkWinners()}');
  }
}
