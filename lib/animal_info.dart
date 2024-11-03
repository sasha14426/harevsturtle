class AnimalInfo {
  final String name;
  final int endurance;
  final int minSpeed;
  final int maxSpeed;
  final String species;

  AnimalInfo({
    required this.name,
    required this.endurance,
    required this.minSpeed,
    required this.maxSpeed,
    required this.species,
  });

  factory AnimalInfo.fromJson(Map<String, dynamic> json) {
    return AnimalInfo(
      name: json['name'],
      endurance: json['endurance'],
      minSpeed: json['minSpeed'],
      maxSpeed: json['maxSpeed'],
      species: json['species'],
    );
  }

  @override
  String toString() => name;
}
