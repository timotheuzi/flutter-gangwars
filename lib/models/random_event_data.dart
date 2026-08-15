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
      title: '🩸 TERRITORY DISPUTE',
      description:
          'A pack of starving rival thugs corners you. "You\'re breathing our air, dead man." Their eyes are hollow, filled only with the desire to see your blood in the mud. Fight or die?',
      type: EventType.gangFight,
      options: ['YES (FIGHT)', 'NO (FLEE)'],
    );
  }

  static RandomEvent _createPoliceChaseEvent() {
    return RandomEvent(
      id: 'police_chase_${DateTime.now().millisecondsSinceEpoch}',
      title: '⚖️ STATE RECKONING',
      description:
          'Blue and red strobes cut through the smog. The state\'s armored hounds have caught your scent. Surrender means a shallow grave in the prison pits. Escape or be erased?',
      type: EventType.policeChase,
      options: ['YES (RUN)', 'NO (SURRENDER)'],
    );
  }

  static RandomEvent _createSquidieHitSquadEvent() {
    return RandomEvent(
      id: 'squidie_hit_${DateTime.now().millisecondsSinceEpoch}',
      title: '🦑 ABYSSAL ASSASSINS',
      description:
          'The shadows themselves seem to grow tentacles. Squidie hitmen, their skin slick with bioluminescent filth, emerge from the blackness. They don\'t want your money—they want your soul. Stand your ground?',
      type: EventType.squidieHitSquad,
      options: ['YES (FIGHT)', 'NO (HIDE)'],
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
      'Rival Gang Leader',
    ];
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
      title: '👤 DARK ENCOUNTER: $npcType',
      description: _getNpcDescription(npcType),
      type: EventType.npcEncounter,
      options: options,
      optionEffects: optionEffects,
    );
  }

  static String _getNpcDescription(String npcType) {
    return switch (npcType) {
      'Street Thug' =>
        'A brute with a jaw of rusted iron blocks your path. "You look like you have too many teeth, friend. I can fix that."',
      'Shady Dealer' =>
        'A figure wrapped in rags that smell of formaldehyde gestures to a bag. "The chemicals will make you a god, or a corpse. Either way, the pain stops."',
      'Bouncer' =>
        'A mountain of scar tissue and synth-muscle stands guard. "You aren\'t on the list of the living. Turn back or be liquidated."',
      'Homeless Person' =>
        'A wretched soul clutching a shattered bottle weeps. "The Squidies took my eyes, boss. Give me a coin so I can buy enough rot-gut to forget the screaming."',
      'Corrupt Businessman' =>
        'A man in a blood-stained suit smiles, his teeth too white for this hellscape. "I trade in information, and your obituary is looking very profitable."',
      'Street Punk' =>
        'A youth with a mohawk of jagged glass sneers. "The old world is dead, old man. We\'re the maggots eating the corpse. Want to join the feast?"',
      'Alleyway Boss' =>
        'A warlord sitting on a throne of spent casings watches you. "Every step you take in this alley is a debt you owe me. Pay in blood or gold."',
      'Drug Lord' =>
        'A kingpin surrounded by silent, masked executioners nods. "The city is a vein, and I am the needle. Do you want to be the poison or the cure?"',
      'Mysterious Stranger' =>
        'A cloaked figure whose shadow moves independently whispers. "I have seen the end. It is dark, it is cold, and you are right in the middle of it."',
      'Rival Gang Leader' =>
        'A rival boss sharpening a jagged blade laughs. "Your gang is a joke, and I\'m the punchline. Let\'s see how much you leak."',
      _ =>
        'A silhouette detaches itself from the gloom, its intentions as dark as the city itself.',
    };
  }

  static RandomEvent _createDrugDealEvent(Random random) {
    final drugs = ['crack', 'coke', 'weed', 'ice', 'percs', 'pixie_dust'];
    final drug = drugs[random.nextInt(drugs.length)];
    final qty = random.nextInt(5) + 1;
    final price = qty * 100;

    return RandomEvent(
      id: 'drug_deal_${DateTime.now().millisecondsSinceEpoch}',
      title: '💊 CHEMICAL PACT',
      description:
          'A twitching runner offers you $qty kilos of $drug for \$$price. The product glows with an unnatural, sickly light. Seal the deal?',
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
      title: '💰 CORPSE LOOT',
      description:
          'You find a body face-down in a pool of iridescent sludge. A bag of blood-soaked cash (\$$amount) is clutched in its cold, stiff fingers. Take it?',
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
      title: '💉 STOLEN LIFE',
      description:
          'An abandoned medical drone sits sparking in a corner. Its needles are dirty, but its tanks are full of experimental stims. Inject yourself?',
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
      title: '⚔️ DESPERATE ARMORY',
      description:
          'Hidden beneath a pile of charred remains, you find a $weapon. It is stained with old blood, but the mechanism still hungry for more. Claim it?',
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
      title: '🪤 THE SLAUGHTERHOUSE',
      description:
          'The door clicks shut behind you. Tripwires hum in the dark. It\'s an ambush, and the floor is slick with the grease of previous victims. Fight through the gore?',
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
      title: '🌑 THE SILENT GRAVE',
      description:
          'The streets are silent, save for the dripping of something thick and metallic from the overhead pipes. Not a soul dares to move. You are alone with your sins.',
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
