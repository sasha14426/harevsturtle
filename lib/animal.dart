import 'dart:math';

import 'animal_info.dart';

class Animal {
  final AnimalInfo info;
  int distance = 0;

  final Random random = Random();

  Animal(this.info);

  void move() {
    final step = random.nextInt(info.maxSpeed - info.minSpeed) + info.minSpeed;

    if (_isEndurance()) {
      distance += step;
    }
  }

  bool _isEndurance() =>
      1 - pow(1 - 1/info.endurance, 22) < random.nextDouble();

  @override
  String toString() => info.name;
}
