enum EventType {
  gangFight,
  policeChase,
  squidieHitSquad,
  npcEncounter,
  drugDeal,
  moneyFound,
  healthRestore,
  weaponFound,
  trap,
  nothing,
}

class RandomEvent {
  final String id;
  final String title;
  final String description;
  final EventType type;
  final List<String> options;
  final Map<String, Map<String, int>> optionEffects;

  RandomEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.options = const [],
    this.optionEffects = const {},
  });
}
