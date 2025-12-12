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
      // Combat events
      if (gameState.reputation > 50) EventType.gangFight,
      if (gameState.loan > 0) EventType.policeChase,
      if (gameState.members > 5) EventType.squidieHitSquad,

      // NPC events
      EventType.npcEncounter,
      EventType.npcEncounter,
      EventType.npcEncounter,

      // Positive events
      EventType.drugDeal,
      EventType.moneyFound,
      EventType.healthRestore,
      EventType.weaponFound,

      // Negative events
      EventType.trap,

      // Neutral events
      EventType.nothing,
      EventType.nothing,
    ];

    if (eventChances.isEmpty) {
      return EventType.nothing;
    }

    return eventChances[random.nextInt(eventChances.length)];
  }

  static RandomEvent _createGangFightEvent() {
    return RandomEvent(
      id: 'gang_fight_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Gang Fight!',
      description:
          'A rival gang challenges you! They want to take over your territory.',
      type: EventType.gangFight,
    );
  }

  static RandomEvent _createPoliceChaseEvent() {
    return RandomEvent(
      id: 'police_chase_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Police Chase!',
      description:
          'The police have spotted your illegal activities! They\'re coming after you.',
      type: EventType.policeChase,
    );
  }

  static RandomEvent _createSquidieHitSquadEvent() {
    return RandomEvent(
      id: 'squidie_hit_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Squidie Hit Squad!',
      description:
          'The Squidie gang has sent assassins to eliminate you! They won\'t stop until you\'re dead.',
      type: EventType.squidieHitSquad,
    );
  }

  static RandomEvent _createNpcEncounterEvent(Random random) {
    final npcTypes = [
      'Street Thug',
      'Shady Dealer',
      'Bouncer',
      'Homeless Person',
      'Corrupt Businessman',
      'Street Punk',
      'Alleyway Boss',
      'Drug Lord',
      'Mysterious Stranger',
      'Rival Gang Leader'
    ];
    final npcType = npcTypes[random.nextInt(npcTypes.length)];

    final options = <String>[];
    final optionEffects = <String, Map<String, int>>{};

    // Add basic options
    options.add('Fight');
    optionEffects['Fight'] = {'damage': 10};

    options.add('Talk');
    optionEffects['Talk'] = {'health': 5, 'money': 100};

    options.add('Flee');
    optionEffects['Flee'] = {'damage': 5, 'money': -50};

    // Add special options based on NPC type
    if (npcType == 'Shady Dealer' || npcType == 'Corrupt Businessman' || npcType == 'Drug Lord') {
      options.add('Trade Drugs');
      optionEffects['Trade Drugs'] = {'money': -200, 'drugs': 2};
    }

    if (npcType == 'Bouncer' || npcType == 'Street Punk' || npcType == 'Rival Gang Leader') {
      options.add('Recruit');
      optionEffects['Recruit'] = {'money': -5000, 'members': 1};
    }

    if (npcType == 'Mysterious Stranger' || npcType == 'Homeless Person') {
      options.add('Get Info');
      optionEffects['Get Info'] = {'money': -100, 'reputation': 5};
    }

    if (npcType == 'Alleyway Boss' || npcType == 'Rival Gang Leader') {
      options.add('Challenge');
      optionEffects['Challenge'] = {'damage': 20, 'reputation': 10};
    }

    return RandomEvent(
      id: 'npc_${DateTime.now().millisecondsSinceEpoch}',
      title: 'NPC Encounter: $npcType',
      description: _getNpcDescription(npcType),
      type: EventType.npcEncounter,
      options: options,
      optionEffects: optionEffects,
    );
  }

  static String _getNpcDescription(String npcType) {
    return switch (npcType) {
      'Street Thug' =>
        'A tough-looking thug blocks your path. He looks like he wants trouble. "You lookin\' at me, punk?"',
      'Shady Dealer' =>
        'A shady character in a trench coat approaches you. "Psst... I got the good stuff. Wanna make a deal?"',
      'Bouncer' =>
        'A massive bouncer stands guard. He might be useful if you can convince him to join you. "This area is off limits."',
      'Homeless Person' =>
        'A homeless person mutters to themselves. They might have useful information. "Spare some change, boss?"',
      'Corrupt Businessman' =>
        'A well-dressed businessman with a shady aura offers you a deal. "I have connections... for the right price."',
      'Street Punk' =>
        'A young punk with attitude challenges you. He could be a valuable recruit. "You think you\'re tough? Prove it!"',
      'Alleyway Boss' =>
        'A powerful figure emerges from the shadows. This is the boss of this territory. "You dare enter my domain?"',
      'Drug Lord' =>
        'A wealthy drug lord surrounded by bodyguards offers you a business proposition. "I control the trade here..."',
      'Mysterious Stranger' =>
        'A cloaked figure whispers secrets of the dark alleyway. "I know things... dangerous things."',
      'Rival Gang Leader' =>
        'The leader of a rival gang challenges you. "This turf belongs to us! Prepare to fight!"',
      _ => 'Someone approaches you in the dark alleyway.',
    };
  }

  static RandomEvent _createDrugDealEvent(Random random) {
    final drugs = ['crack', 'coke', 'weed', 'ice', 'percs', 'pixie_dust'];
    final drug = drugs[random.nextInt(drugs.length)];
    final quantity = random.nextInt(5) + 1;
    final price = quantity * 100;

    return RandomEvent(
      id: 'drug_deal_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Drug Deal Opportunity',
      description:
          'A dealer offers you $quantity kilos of $drug for \$${price.toString()}. Do you want to buy?',
      type: EventType.drugDeal,
    );
  }

  static RandomEvent _createMoneyFoundEvent(Random random) {
    final amount = (random.nextInt(10) + 1) * 100;

    return RandomEvent(
      id: 'money_found_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Money Found!',
      description:
          'You found a stash of cash! \$${amount.toString()} added to your pocket.',
      type: EventType.moneyFound,
    );
  }

  static RandomEvent _createHealthRestoreEvent() {
    return RandomEvent(
      id: 'health_restore_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Health Restored',
      description:
          'You found a first aid kit! Your health is partially restored.',
      type: EventType.healthRestore,
    );
  }

  static RandomEvent _createWeaponFoundEvent() {
    final weapons = [
      'pistol',
      'knife',
      'brass_knuckles',
      'bullets',
      'uzi',
      'grenade',
      'vest_light'
    ];
    final weapon = weapons[Random().nextInt(weapons.length)];

    return RandomEvent(
      id: 'weapon_found_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Weapon Found!',
      description: 'You found a $weapon! This could be useful in combat.',
      type: EventType.weaponFound,
    );
  }

  static RandomEvent _createTrapEvent() {
    return RandomEvent(
      id: 'trap_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Trap Encountered!',
      description:
          'You stepped into a trap! Your health is reduced and you lost some money.',
      type: EventType.trap,
    );
  }

  static RandomEvent _createNothingEvent() {
    return RandomEvent(
      id: 'nothing_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Nothing Happened',
      description: 'You wander the streets but nothing interesting happens.',
      type: EventType.nothing,
    );
  }

  static bool hasMeetRequirements(RandomEvent event, GameState gameState) {
    // Check if event has specific requirements
    return switch (event.type) {
      EventType.gangFight => gameState.reputation > 30,
      EventType.policeChase =>
        gameState.loan > 0 || gameState.flags.hasId == false,
      EventType.squidieHitSquad => gameState.members > 3,
      _ => true,
    };
  }

  static void applyEventEffects(RandomEvent event, GameState gameState) {
    switch (event.type) {
      case EventType.moneyFound:
        final amount =
            int.tryParse(event.description.split('\$').last.split(' ').first) ??
                100;
        gameState.money += amount;
      case EventType.healthRestore:
        gameState.heal(20);
      case EventType.trap:
        gameState.takeDamage(15);
        gameState.money -= 50;
      case EventType.drugDeal:
        // This would be handled by the trade system
        break;
      case EventType.weaponFound:
        // This would be handled by the weapon system
        break;
      default:
        // No direct effects for combat events
        break;
    }
  }
}
