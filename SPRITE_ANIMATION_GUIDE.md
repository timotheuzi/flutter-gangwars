# Gang Wars - Sprite & Animation Guide

## Overview

This guide documents the comprehensive pixelated sprite and animation system added to Gang Wars. The system provides smooth, pixelated animations for all game situations with a consistent retro aesthetic.

## New Files Added

### 1. `lib/widgets/advanced_animations.dart`
Advanced animation system with particle effects, character animations, weapon animations, vehicle animations, explosions, weather effects, UI transitions, damage indicators, status effects, and loading animations.

### 2. `lib/widgets/comprehensive_sprites.dart`
Complete sprite system with pixelated sprites for all game entities including police, civilians, drugs, money, vehicles, buildings, weapons, effects, UI elements, and health/armor.

### 3. `lib/widgets/sprite_integration_demo.dart`
Interactive demo showcasing all new sprites and animations with categorized displays.

### 4. `lib/widgets/cut_scene_system.dart`
Comprehensive cut scene system for important game events including gang fights, drug usage, police raids, and more.

## Animation Categories

### Character Animations
- **States**: Idle, walking, running, attacking, hurt, dying, celebrating
- **Features**: Smooth bobbing, shaking, rotation effects
- **Usage**: `AdvancedAnimations.createCharacterAnimation()`

### Weapon Animations
- **Types**: Pistol, Uzi, AR15, shotgun, knife, bat, grenade, vest
- **States**: Idle, firing, reloading, dropped
- **Features**: Recoil animation, muzzle flash effects
- **Usage**: `AdvancedAnimations.createWeaponAnimation()`

### Vehicle Animations
- **Types**: Car, truck, motorcycle, police, ambulance, taxi
- **States**: Idle, moving, crashed, exploding
- **Features**: Bouncing motion, rotating wheels, state-specific effects
- **Usage**: `AdvancedAnimations.createVehicleAnimation()`

### Explosion Animations
- **Types**: Small, medium, large, fire, smoke
- **Features**: Pixelated debris, expanding core, gravity effects
- **Usage**: `AdvancedAnimations.createExplosionAnimation()`

### Weather Effects
- **Types**: Rain, snow, fog, dust
- **Features**: Particle systems, realistic motion patterns
- **Usage**: `AdvancedAnimations.createWeatherAnimation()`

### UI Transitions
- **Types**: Fade, slide, scale, rotate
- **Features**: Smooth easing curves, pixel-perfect rendering
- **Usage**: `AdvancedAnimations.createUITransition()`

### Damage Indicators
- **Features**: Floating numbers, critical hit styling, fade-out effects
- **Usage**: `AdvancedAnimations.createDamageIndicator()`

### Status Effects
- **Types**: Poison, burn, freeze, boost, shield
- **Features**: Pulsing animations, color-coded effects
- **Usage**: `AdvancedAnimations.createStatusEffect()`

### Loading Animations
- **Features**: Pixelated spinner, customizable colors
- **Usage**: `AdvancedAnimations.createLoadingAnimation()`

## Sprite Categories

### Police Sprites
- **States**: Idle, alert, chasing, shooting, arresting, hurt, dead
- **Features**: Animated hat, badge, weapon poses, state indicators
- **Usage**: `ComprehensiveSprites.createPoliceSprite()`

### Civilian Sprites
- **Types**: Man, woman, child, elderly, homeless
- **States**: Idle, walking, running, scared, dead
- **Features**: Type-specific clothing, hair colors, expressions
- **Usage**: `ComprehensiveSprites.createCivilianSprite()`

### Drug Sprites
- **Types**: Weed, crack, coke, ice, percs, pixie dust
- **States**: Idle, floating, collected, consumed
- **Features**: Unique shapes per type, glow effects, floating animation
- **Usage**: `ComprehensiveSprites.createDrugSprite()`

### Money Sprites
- **Denominations**: Penny, nickel, dime, quarter, dollar, five, ten, twenty, fifty, hundred
- **States**: Idle, floating, collected, counting
- **Features**: Coin/bill shapes, denomination-specific colors, spinning effects
- **Usage**: `ComprehensiveSprites.createMoneySprite()`

### Vehicle Sprites
- **Types**: Car, truck, motorcycle, police, ambulance, taxi
- **States**: Idle, moving, crashed, exploding
- **Features**: Rotating wheels, type-specific details, damage effects
- **Usage**: `ComprehensiveSprites.createVehicleSprite()`

### Building Sprites
- **Types**: House, store, bank, bar, crackhouse, gunshack, hospital, police
- **States**: Idle, damaged, burning, destroyed
- **Features**: Type-specific architecture, window lights, damage effects
- **Usage**: `ComprehensiveSprites.createBuildingSprite()`

### Weapon Sprites
- **Types**: Pistol, Uzi, AR15, shotgun, knife, bat, grenade, vest
- **States**: Idle, firing, reloading, dropped
- **Features**: Detailed pixel art, muzzle flash, recoil animation
- **Usage**: `ComprehensiveSprites.createWeaponSprite()`

### Effect Sprites
- **Types**: Muzzle flash, explosion, blood, smoke, fire, spark, trail
- **States**: Idle, active, fading
- **Features**: Particle systems, color gradients, fade effects
- **Usage**: `ComprehensiveSprites.createEffectSprite()`

### UI Sprites
- **Types**: Button, icon, bar, frame, cursor, menu
- **States**: Idle, active, selected, disabled
- **Features**: Pixel-perfect borders, highlight effects, state indicators
- **Usage**: `ComprehensiveSprites.createUISprite()`

### Health Sprites
- **Types**: Heart, shield, pill, bandage, first aid kit
- **States**: Idle, active, damaged, healed
- **Features**: Pulsing animations, color-coded states
- **Usage**: `ComprehensiveSprites.createHealthSprite()`

## Cut Scene System

The cut scene system provides cinematic sequences for important game events. All cut scenes are modal dialogs that can be skipped by the player.

### Available Cut Scenes

#### 1. Gang Fight Cut Scene
```dart
await CutSceneManager.showGangFightCutScene(
  context: context,
  playerGangName: 'Your Gang',
  enemyGangName: 'Rival Gang',
  playerMembers: 5,
  enemyMembers: 4,
  onComplete: () {
    // Continue with fight logic
  },
);
```
**Features:**
- Animated confrontation sequence
- VS screen with gang names
- Dynamic fight action symbols (👊, 🦵, 💥, 💨)
- Screen shake effects
- Phased progression (confrontation → fight → intense combat → resolution)

#### 2. Drug Usage Cut Scene
```dart
await CutSceneManager.showDrugUsageCutScene(
  context: context,
  drugType: 'weed',
  userName: 'Player',
  quantity: 1,
  onComplete: () {
    // Apply drug effects
  },
);
```
**Features:**
- Drug-specific color themes (green for weed, white for coke, etc.)
- Pulsing visual effects
- Floating particles
- Phased progression (preparation → usage → effects → peak → coming down)
- Radial gradient background effects

#### 3. Drug Deal Cut Scene
```dart
await CutSceneManager.showDrugDealCutScene(
  context: context,
  drugType: 'coke',
  dealerName: 'Street Dealer',
  quantity: 5,
  price: 500,
  isSuccessful: true,
  onComplete: () {
    // Handle deal result
  },
);
```
**Features:**
- Dealer and player character display
- Drug and money sprite exchange
- Success/failure indicators
- Deal information display
- Phased progression (meeting → negotiation → exchange → result → conclusion)

#### 4. Police Raid Cut Scene
```dart
await CutSceneManager.showPoliceRaidCutScene(
  context: context,
  locationName: 'Crack House',
  policeCount: 4,
  isPlayerCaught: false,
  onComplete: () {
    // Handle raid outcome
  },
);
```
**Features:**
- Animated siren effects (red/blue color switching)
- Police vehicle sprites
- Officer deployment animation
- Player capture indicator
- Phased progression (sirens approach → police arrive → raid begins → chaos → resolution)

#### 5. Territory Takeover Cut Scene
```dart
await CutSceneManager.showTerritoryTakeoverCutScene(
  context: context,
  territoryName: 'Downtown',
  oldGangName: 'Rivals',
  newGangName: 'Your Gang',
  onComplete: () {
    // Update territory ownership
  },
);
```
**Features:**
- Building sprite display
- Animated flag lowering/raising
- Gang member display
- Phased progression (arrival → confrontation → takeover → new flag → victory)

#### 6. Boss Fight Cut Scene
```dart
await CutSceneManager.showBossFightCutScene(
  context: context,
  bossName: 'Kingpin',
  bossGangName: 'The Syndicate',
  weaponType: 'ar15',
  onComplete: () {
    // Start boss fight
  },
);
```
**Features:**
- Dramatic zoom-in animation
- Boss character and weapon display
- Screen shake effects
- Taunt dialogue
- Phased progression (introduction → boss appears → taunt → fight begins → ready)

#### 7. Player Death Cut Scene
```dart
await CutSceneManager.showPlayerDeathCutScene(
  context: context,
  killerName: 'Enemy Gang Member',
  weaponType: 'pistol',
  locationName: 'Back Alley',
  onComplete: () {
    // Handle player death
  },
);
```
**Features:**
- Dramatic zoom effect
- Killer and weapon display
- Player death animation (rotation, falling)
- Blood effect painter
- Fade to black
- Phased progression (hit → falling → on ground → vision fading → death)

#### 8. Victory Cut Scene
```dart
await CutSceneManager.showVictoryCutScene(
  context: context,
  enemyGangName: 'Rival Gang',
  moneyEarned: 1000,
  territoryGained: 2,
  onComplete: () {
    // Apply rewards
  },
);
```
**Features:**
- Confetti animation
- Enemy defeated indicator
- Reward display (money + territory)
- Player celebration
- Phased progression (victory announcement → enemy defeated → rewards → celebration → complete)

## Integration Examples

### Basic Character Animation
```dart
AdvancedAnimations.createCharacterAnimation(
  isPlayer: true,
  state: CharacterState.walking,
  size: 60,
  onAnimationComplete: () {
    print('Animation complete!');
  },
)
```

### Weapon with Firing Effect
```dart
ComprehensiveSprites.createWeaponSprite(
  size: 60,
  type: WeaponType.pistol,
  state: WeaponState.firing,
  isAnimated: true,
)
```

### Weather Effect
```dart
AdvancedAnimations.createWeatherAnimation(
  type: WeatherType.rain,
  intensity: 0.7,
  containerSize: Size(400, 300),
)
```

### Damage Indicator
```dart
AdvancedAnimations.createDamageIndicator(
  damage: 25,
  isCritical: true,
  position: Offset(100, 150),
)
```

### Status Effect
```dart
AdvancedAnimations.createStatusEffect(
  type: StatusEffectType.poison,
  size: 40,
  duration: Duration(seconds: 5),
)
```

## Performance Considerations

### Animation Optimization
- All animations use `SingleTickerProviderStateMixin` for efficiency
- Particle systems have configurable lifespans to prevent memory leaks
- Custom painters are used for pixel-perfect rendering
- Animation controllers are properly disposed

### Sprite Optimization
- Sprites are rendered using `CustomPaint` for maximum performance
- Pixel size is calculated once per frame
- State changes trigger minimal repaints
- Complex shapes use efficient path drawing

### Memory Management
- Animation controllers are disposed in `dispose()` methods
- Particle lists are cleared when animations complete
- No external image assets required (all procedural)
- Minimal object creation during animation

## Testing the System

### Running the Demo
1. Add `SpriteIntegrationDemo` to your app's navigation
2. Run the app and navigate to the demo screen
3. Use the category buttons to browse different sprite types
4. Observe animations and verify smooth performance

### Integration Testing
1. Replace existing sprites with new comprehensive sprites
2. Test all game situations (combat, driving, building entry)
3. Verify performance on target devices
4. Check for any rendering issues

### Performance Testing
1. Monitor frame rates during complex animations
2. Test with multiple simultaneous animations
3. Verify memory usage stays stable
4. Check for any animation glitches

## Customization

### Color Schemes
All sprites use customizable color schemes. Modify the `ColorScheme` class in `comprehensive_sprites.dart` to change:
- Primary colors
- Secondary colors
- Accent colors
- Background colors

### Animation Timing
Adjust animation durations in the respective animation classes:
- Character bob speed
- Weapon recoil timing
- Vehicle bounce frequency
- Effect fade duration

### Sprite Details
Modify pixel art details in the painter classes:
- Add/remove pixel details
- Change proportions
- Adjust color gradients
- Modify animation curves

## Best Practices

### Usage Guidelines
1. Always use the provided factory methods for creating sprites
2. Set `isAnimated: false` for static displays to improve performance
3. Use appropriate sizes for different contexts (UI vs game world)
4. Dispose of animations properly to prevent memory leaks

### Performance Tips
1. Limit the number of simultaneous particle systems
2. Use smaller sprite sizes for background elements
3. Disable animations when not visible
4. Cache frequently used sprites when possible

### Styling Consistency
1. Use the same sprite size for similar elements
2. Maintain consistent animation speeds within categories
3. Use appropriate state indicators for different situations
4. Follow the established color schemes

## Troubleshooting

### Common Issues
1. **Animation not playing**: Check if `isAnimated: true` is set
2. **Performance drops**: Reduce particle count or sprite size
3. **Rendering glitches**: Verify `CustomPainter` implementations
4. **Memory leaks**: Ensure proper disposal of controllers

### Debug Tips
1. Use Flutter's performance overlay to monitor frame rates
2. Check the debug console for any animation-related errors
3. Test on different devices to verify compatibility
4. Use the demo screen to isolate issues

## Future Enhancements

### Planned Features
1. **Sound Integration**: Add sound effects for animations
2. **More Sprite Types**: Additional character and vehicle variants
3. **Advanced Effects**: More complex particle systems
4. **Animation Sequences**: Chained animations for complex actions

### Extension Points
1. **Custom Animations**: Easy to add new animation types
2. **Sprite Variants**: Simple to create new sprite variations
3. **Effect Combinations**: Combine multiple effects for complex visuals
4. **State Machines**: Implement more sophisticated state management

## Conclusion

The comprehensive sprite and animation system provides Gang Wars with:
- **Consistent pixelated aesthetic** across all game elements
- **Smooth animations** for all game situations
- **High performance** with optimized rendering
- **Easy integration** with existing game code
- **Extensive customization** options
- **Complete documentation** for maintenance and extension

This system significantly enhances the visual appeal and gameplay experience while maintaining the retro pixel art style that defines Gang Wars.