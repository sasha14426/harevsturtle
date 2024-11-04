import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hare_vs_turtle/animal.dart';
import 'package:hare_vs_turtle/animal_info.dart';
import 'package:mocktail/mocktail.dart';

class MockRandom extends Mock implements Random {}

void main() {
  late Animal animal;
  late AnimalInfo animalInfo;
  late MockRandom random;

  setUp(() {
    animalInfo = AnimalInfo(
      name: 'Hare',
      maxSpeed: 5,
      minSpeed: 1,
      endurance: 50,
      species: 'Hare',
    );

    random = MockRandom();
    animal = Animal(animalInfo, random);
  });

  test('Animal move', () {
    when(() => random.nextDouble()).thenReturn(1.0);
    when(() => random.nextInt(any())).thenReturn(0);
    final prevDistance = animal.distance.toInt();

    animal.move();
    
    expect(animal.distance, equals(prevDistance + animal.info.minSpeed));
  });
}
