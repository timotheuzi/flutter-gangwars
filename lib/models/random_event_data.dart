import 'dart:math';
import '../models/game_state.dart';
import '../models/random_event.dart';

class RandomEventData {
  static RandomEvent generateRandomEvent(GameState gameState) {
    final random = Random();
    final eventType = _getRandomEventType(random, gameState);

    return switch (eventType) {
      EventType.gangFight => _createGangFightEvent(),
      EventType.policeChase => _createPoliceChaseEvent(),
      EventType.squidieHitSquad => _createSquidieHitSquadEvent(),
      EventType.npcEncounter => _createNpcEncounterEvent(random),
      EventType.drugDeal => _createDrugDealEvent(random),
      EventType.moneyFound => _createMoneyFoundEvent(random),
      EventType.healthRestore => _createHealthRestoreEvent(),
      EventType.weaponFound => _createWeaponFoundEvent(),
      EventType.trap => _createTrapEvent(),
      EventType.nothing => _createNothingEvent(),
    };
  }

  static EventType _getRandomEventType(Random random, GameState gameState) {
    final eventChances = [
      if (gameState.reputation > 50) EventType.gangFight,
      if (gameState.loan > 0) EventType.policeChase,
      if (gameState.members > 5) EventType.squidieHitSquad,
      EventType.npcEncounter,
      EventType.npcEncounter,
      EventType.npcEncounter,
      EventType.drugDeal,
      EventType.moneyFound,
      EventType.healthRestore,
      EventType.weaponFound,
      EventType.trap,
      EventType.nothing,
      EventType.nothing,
    ];

    return eventChances[random.nextInt(eventChances.length)];
  }

  static RandomEvent _createGangFightEvent() {
    return RandomEvent(
      id: 'gang_fight_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Gang Fight!',
      description: 'A rival gang challenges you! They want to take over your territory. Fight them off?',
      type: EventType.gangFight,
      options: ['YES (FIGHT)', 'NO (FLEE)'],
    );
  }

  static RandomEvent _createPoliceChaseEvent() {
    return RandomEvent(
      id: 'police_chase_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Police Chase!',
      description: 'The police have spotted your illegal activities! Attempt to escape?',
      type: EventType.policeChase,
      options: ['YES (RUN)', 'NO (SURRENDER)'],
    );
  }

  static RandomEvent _createSquidieHitSquadEvent() {
    return RandomEvent(
      id: 'squidie_hit_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Squidie Hit Squad!',
      description: 'assassins from the Squidie gang have found you! Stand and fight?',
      type: EventType.squidieHitSquad,
      options: ['YES (FIGHT)', 'NO (HIDE)'],
    );
  }

  static RandomEvent _createNpcEncounterEvent(Random random) {
    final npcTypes = ['Street Thug', 'Shady Dealer', 'Bouncer', 'Homeless Person', 'Corrupt Businessman', 'Street Punk', 'Alleyway Boss', 'Drug Lord', 'Mysterious Stranger', 'Rival Gang Leader'];
    final npcType = npcTypes[random.nextInt(npcTypes.length)];

    final options = ['Talk', 'Fight', 'Flee'];
    final optionEffects = <String, Map<String, int>>{
      'Fight': {'damage': 10},
      'Talk': {'health': 5, 'money': 100},
      'Flee': {'damage': 5, 'money': -50},
    };

    if (npcType == 'Shady Dealer' || npcType == 'Drug Lord') {
      options.add('Trade');
      optionEffects['Trade'] = {'money': -200, 'drugs': 2};
    }

    if (npcType == 'Street Punk' || npcType == 'Rival Gang Leader') {
      options.add('Recruit');
      optionEffects['Recruit'] = {'money': -5000, 'members': 1};
    }

    return RandomEvent(
      id: 'npc_${DateTime.now().millisecondsSinceEpoch}',
      title: 'NPC: $npcType',
      description: _getNpcDescription(npcType),
      type: EventType.npcEncounter,
      options: options,
      optionEffects: optionEffects,
    );
  }

  static String _getNpcDescription(String npcType) {
    return switch (npcType) {
      'Street Thug' => 'A tough-looking thug blocks your path. "You lookin\' at me, punk?"',
      'Shady Dealer' => 'A character in a trench coat approaches. "Psst... I got the good stuff. Wanna make a deal?"',
      'Bouncer' => 'A massive bouncer stands guard. "This area is off limits."',
      'Homeless Person' => 'A homeless person mutters to themselves. "Spare some change, boss?"',
      'Corrupt Businessman' => 'A businessman with a shady aura offers you a deal. "I have connections... for the right price."',
      'Street Punk' => 'A young punk challenges you. "You think you\'re tough? Prove it!"',
      'Alleyway Boss' => 'A powerful figure emerges from the shadows. "You dare enter my domain?"',
      'Drug Lord' => 'A wealthy drug lord surrounded by bodyguards offers a proposition.',
      'Mysterious Stranger' => 'A cloaked figure whispers secrets. "I know things... dangerous things."',
      'Rival Gang Leader' => 'The leader of a rival gang challenges you. "This turf belongs to us!"',
      _ => 'Someone approaches you in the darkness.',
    };
  }

  static RandomEvent _createDrugDealEvent(Random random) {
    final drugs = ['crack', 'coke', 'weed', 'ice', 'percs', 'pixie_dust'];
    final drug = drugs[random.nextInt(drugs.length)];
    final qty = random.nextInt(5) + 1;
    final price = qty * 100;

    return RandomEvent(
      id: 'drug_deal_${DateTime.now().millisecondsSinceEpoch}',
      title: 'STREET DEAL',
      description: 'A local runner offers you $qty kilos of $drug for \$$price. Take the deal?',
      type: EventType.drugDeal,
      options: ['YES', 'NO'],
      optionEffects: {
        'YES': {'money': -price, 'drugs': qty},
        'NO': {},
      },
    );
  }

  static RandomEvent _createMoneyFoundEvent(Random random) {
    final amount = (random.nextInt(10) + 1) * 100;
    return RandomEvent(
      id: 'money_found_${DateTime.now().millisecondsSinceEpoch}',
      title: 'LUCKY FIND',
      description: 'You found a discarded bag of cash! \$$amount is inside. Pick it up?',
      type: EventType.moneyFound,
      options: ['YES', 'NO'],
      optionEffects: {
        'YES': {'money': amount},
        'NO': {},
      },
    );
  }

  static RandomEvent _createHealthRestoreEvent() {
    return RandomEvent(
      id: 'health_restore_${DateTime.now().millisecondsSinceEpoch}',
      title: 'FIRST AID',
      description: 'You found a clean medical kit in an abandoned clinic. Use it?',
      type: EventType.healthRestore,
      options: ['YES', 'NO'],
      optionEffects: {
        'YES': {'health': 30},
        'NO': {},
      },
    );
  }

  static RandomEvent _createWeaponFoundEvent() {
    final weapons = ['pistol', 'knife', 'brass_knuckles', 'bullets', 'uzi'];
    final weapon = weapons[Random().nextInt(weapons.length)];
    return RandomEvent(
      id: 'weapon_found_${DateTime.now().millisecondsSinceEpoch}',
      title: 'STASH FOUND',
      description: 'You found a hidden stash containing a $weapon! Take it?',
      type: EventType.weaponFound,
      options: ['YES', 'NO'],
      optionEffects: {
        'YES': {}, // Handled specially in logic
        'NO': {},
      },
    );
  }

  static RandomEvent _createTrapEvent() {
    return RandomEvent(
      id: 'trap_${DateTime.now().millisecondsSinceEpoch}',
      title: 'AMBUSH!',
      description: 'It\'s a trap! You\'ve been led into an ambush. Fight your way out?',
      type: EventType.trap,
      options: ['YES (FIGHT)', 'NO (RUN)'],
      optionEffects: {
        'YES': {'damage': 10},
        'NO': {'damage': 20, 'money': -100},
      },
    );
  }

  static RandomEvent _createNothingEvent() {
    return RandomEvent(
      id: 'nothing_${DateTime.now().millisecondsSinceEpoch}',
      title: 'SILENT STREETS',
      description: 'The streets are unusually quiet today. Nothing to report.',
      type: EventType.nothing,
    );
  }

  static bool hasMeetRequirements(RandomEvent event, GameState gameState) {
    return switch (event.type) {
      EventType.gangFight => gameState.reputation > 30,
      EventType.policeChase => gameState.loan > 0 || !gameState.flags.hasId,
      EventType.squidieHitSquad => gameState.members > 3,
      _ => true,
    };
  }

  static void applyEventEffects(RandomEvent event, GameState gameState) {
    // Basic automatic effects moved to option selection logic in GameProvider
  }
}
