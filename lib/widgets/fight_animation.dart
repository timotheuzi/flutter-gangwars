import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

class FightAction {
  final String actionType; // 'punch', 'shoot', 'stab', 'hit', 'kill'
  final Offset position;
  final Color color;
  final double size;
  final int life;
  int currentLife;

  FightAction({
    required this.actionType,
    required this.position,
    required this.color,
    required this.size,
    required this.life,
  }) : currentLife = life;
}

class GangMember {
  final int index;
  final bool isPlayer;
  bool isAlive;
  Offset position;
  Offset targetPosition;
  double walkProgress;
  MemberAnimationState animationState;
  int attackCooldown;
  bool isAttacking;
  double attackProgress;

  GangMember({
    required this.index,
    required this.isPlayer,
    required this.isAlive,
    required this.position,
    Offset? targetPosition,
    this.walkProgress = 0.0,
    this.animationState = MemberAnimationState.idle,
    this.attackCooldown = 0,
    this.isAttacking = false,
    this.attackProgress = 0.0,
  }) : targetPosition = targetPosition ?? position;
}

enum MemberAnimationState { idle, walking, attacking, shooting, hit, dead }

class FightAnimation extends StatefulWidget {
  final String playerName;
  final String gangName;
  final String enemyType;
  final int playerHealth;
  final int enemyHealth;
  final double playerMaxHealth;
  final double enemyMaxHealth;
  final int playerMembers;
  final int enemyCount;
  final String? currentWeapon;
  final bool showBloodEffects;

  const FightAnimation({
    super.key,
    required this.playerName,
    required this.gangName,
    required this.enemyType,
    required this.playerHealth,
    required this.enemyHealth,
    required this.playerMaxHealth,
    required this.enemyMaxHealth,
    required this.playerMembers,
    required this.enemyCount,
    this.currentWeapon,
    this.showBloodEffects = false,
  });

  @override
  FightAnimationState createState() => FightAnimationState();
}

enum ParticleType { blood, gut, muzzleFlash, bullet }

class Particle {
  Offset position;
  Offset velocity;
  double size;
  double opacity;
  double rotation;
  double rotationSpeed;
  Color color;
  ParticleType type;
  int life;
  int maxLife;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.type,
    required this.maxLife,
  }) : life = maxLife;
}

class BloodSplatterPainter extends CustomPainter {
  final List<Particle> particles;

  BloodSplatterPainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final bloodPaint = Paint()..style = PaintingStyle.fill;
    final gutPaint = Paint()..style = PaintingStyle.fill;
    final muzzlePaint = Paint()..style = PaintingStyle.fill;
    final bulletPaint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final currentOpacity =
          particle.opacity * (particle.life / particle.maxLife);

      if (particle.type == ParticleType.blood) {
        bloodPaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);

        final path = Path();
        path.moveTo(0, -particle.size);
        path.quadraticBezierTo(
          particle.size * 0.5,
          -particle.size * 0.8,
          particle.size,
          0,
        );
        path.quadraticBezierTo(
          particle.size * 0.8,
          particle.size * 0.5,
          0,
          particle.size,
        );
        path.quadraticBezierTo(
          -particle.size * 0.8,
          particle.size * 0.5,
          -particle.size,
          0,
        );
        path.quadraticBezierTo(
          -particle.size * 0.5,
          -particle.size * 0.8,
          0,
          -particle.size,
        );

        canvas.drawPath(path, bloodPaint);
        canvas.restore();
      } else if (particle.type == ParticleType.gut) {
        // Guts/Gore: irregular shapes
        gutPaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);

        // Rect for a "chunk"
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              -particle.size / 2,
              -particle.size / 4,
              particle.size,
              particle.size / 2,
            ),
            Radius.circular(particle.size / 4),
          ),
          gutPaint,
        );
        canvas.restore();
      } else if (particle.type == ParticleType.muzzleFlash) {
        // Muzzle flash effect
        muzzlePaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.drawCircle(Offset.zero, particle.size, muzzlePaint);
        canvas.restore();
      } else if (particle.type == ParticleType.bullet) {
        // Bullet trail
        bulletPaint.color = particle.color.withValues(alpha: currentOpacity);
        canvas.save();
        canvas.translate(particle.position.dx, particle.position.dy);
        canvas.rotate(particle.rotation);
        canvas.drawRect(
          Rect.fromLTWH(
            -particle.size * 2,
            -particle.size / 4,
            particle.size * 4,
            particle.size / 2,
          ),
          bulletPaint,
        );
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant BloodSplatterPainter oldDelegate) => true;
}

class FightAnimationState extends State<FightAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final List<FightAction> _fightActions = [];
  final List<GangMember> _playerMembers = [];
  final List<GangMember> _enemyMembers = [];
  final Random _random = Random();
  late Timer _actionTimer;
  late Timer _movementTimer;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 16), // Approx 60fps
          )
          ..addListener(_updateParticles)
          ..repeat();

    // Initialize gang members
    _initializeMembers();

    // Random fight actions
    _actionTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      _spawnRandomAction();
    });

    // Movement updates
    _movementTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateMemberPositions();
    });
  }

  void _initializeMembers() {
    // Clear existing members
    _playerMembers.clear();
    _enemyMembers.clear();

    // Create player members
    for (int i = 0; i < widget.playerMembers; i++) {
      _playerMembers.add(
        GangMember(
          index: i,
          isPlayer: true,
          isAlive: true,
          position: Offset(50 + (i % 3) * 40.0, 100 + (i ~/ 3) * 50.0),
          animationState: MemberAnimationState.idle,
        ),
      );
    }

    // Create enemy members
    for (int i = 0; i < widget.enemyCount; i++) {
      _enemyMembers.add(
        GangMember(
          index: i,
          isPlayer: false,
          isAlive: true,
          position: Offset(
            MediaQuery.of(context).size.width - 150 + (i % 3) * 40.0,
            100 + (i ~/ 3) * 50.0,
          ),
          animationState: MemberAnimationState.idle,
        ),
      );
    }
  }

  void _updateMemberPositions() {
    if (!mounted) return;

    setState(() {
      // Update player members
      for (var member in _playerMembers) {
        if (!member.isAlive) continue;

        // Update walk animation
        if (member.animationState == MemberAnimationState.walking) {
          member.walkProgress += 0.1;
          if (member.walkProgress >= 1.0) {
            member.walkProgress = 0.0;
            member.animationState = MemberAnimationState.idle;
          }
        }

        // Update attack animation
        if (member.isAttacking) {
          member.attackProgress += 0.15;
          if (member.attackProgress >= 1.0) {
            member.isAttacking = false;
            member.attackProgress = 0.0;
            member.animationState = MemberAnimationState.idle;
          }
        }

        // Update attack cooldown
        if (member.attackCooldown > 0) {
          member.attackCooldown--;
        }
      }

      // Update enemy members
      for (var member in _enemyMembers) {
        if (!member.isAlive) continue;

        // Update walk animation
        if (member.animationState == MemberAnimationState.walking) {
          member.walkProgress += 0.1;
          if (member.walkProgress >= 1.0) {
            member.walkProgress = 0.0;
            member.animationState = MemberAnimationState.idle;
          }
        }

        // Update attack animation
        if (member.isAttacking) {
          member.attackProgress += 0.15;
          if (member.attackProgress >= 1.0) {
            member.isAttacking = false;
            member.attackProgress = 0.0;
            member.animationState = MemberAnimationState.idle;
          }
        }

        // Update attack cooldown
        if (member.attackCooldown > 0) {
          member.attackCooldown--;
        }
      }
    });
  }

  void _updateParticles() {
    if (!mounted) return;

    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        final p = _particles[i];
        p.position += p.velocity;
        p.velocity += const Offset(0, 0.2); // Gravity
        p.rotation += p.rotationSpeed;
        p.life--;

        if (p.life <= 0) {
          _particles.removeAt(i);
        }
      }

      // Update fight actions
      for (int i = _fightActions.length - 1; i >= 0; i--) {
        final action = _fightActions[i];
        action.currentLife--;
        if (action.currentLife <= 0) {
          _fightActions.removeAt(i);
        }
      }
    });
  }

  bool _isRangedWeapon() {
    if (widget.currentWeapon == null) return false;
    final weapon = widget.currentWeapon!.toLowerCase();
    return weapon.contains('pistol') ||
        weapon.contains('uzi') ||
        weapon.contains('ar15') ||
        weapon.contains('gun') ||
        weapon.contains('grenade');
  }

  void _spawnRandomAction() {
    if (!mounted) return;

    final isRanged = _isRangedWeapon();

    // Find attacking members
    final attackingPlayers = _playerMembers
        .where((m) => m.isAlive && m.attackCooldown == 0)
        .toList();
    final attackingEnemies = _enemyMembers
        .where((m) => m.isAlive && m.attackCooldown == 0)
        .toList();

    if (attackingPlayers.isEmpty && attackingEnemies.isEmpty) return;

    final isPlayerAttacking =
        attackingPlayers.isNotEmpty &&
        (attackingEnemies.isEmpty || _random.nextBool());
    final attacker = isPlayerAttacking
        ? attackingPlayers[_random.nextInt(attackingPlayers.length)]
        : attackingEnemies[_random.nextInt(attackingEnemies.length)];

    // Set attack state
    attacker.isAttacking = true;
    attacker.attackProgress = 0.0;
    attacker.attackCooldown = 30 + _random.nextInt(20);

    if (isRanged) {
      attacker.animationState = MemberAnimationState.shooting;
      _spawnRangedAttack(attacker, isPlayerAttacking);
    } else {
      attacker.animationState = MemberAnimationState.attacking;
      _spawnMeleeAttack(attacker, isPlayerAttacking);
    }
  }

  void _spawnRangedAttack(GangMember attacker, bool isPlayerAttacking) {
    final muzzlePos = Offset(
      attacker.position.dx + (isPlayerAttacking ? 20 : -20),
      attacker.position.dy + 10,
    );

    // Muzzle flash
    _particles.add(
      Particle(
        position: muzzlePos,
        velocity: Offset.zero,
        size: 8 + _random.nextDouble() * 4,
        opacity: 1.0,
        rotation: 0,
        rotationSpeed: 0,
        color: Colors.yellow,
        type: ParticleType.muzzleFlash,
        maxLife: 5,
      ),
    );

    // Bullet trail
    final targetMembers = isPlayerAttacking ? _enemyMembers : _playerMembers;
    final aliveTargets = targetMembers.where((m) => m.isAlive).toList();
    if (aliveTargets.isNotEmpty) {
      final target = aliveTargets[_random.nextInt(aliveTargets.length)];
      final offset = target.position - muzzlePos;
      final distance = offset.distance;

      if (distance > 0) {
        final direction = offset / distance;

        _particles.add(
          Particle(
            position: muzzlePos,
            velocity: direction * 15,
            size: 3,
            opacity: 1.0,
            rotation: atan2(direction.dy, direction.dx),
            rotationSpeed: 0,
            color: Colors.orange,
            type: ParticleType.bullet,
            maxLife: 20,
          ),
        );
      }
    }

    // Fight action
    _fightActions.add(
      FightAction(
        actionType: 'shoot',
        position: muzzlePos,
        color: Colors.yellow,
        size: 24,
        life: 15,
      ),
    );
  }

  void _spawnMeleeAttack(GangMember attacker, bool isPlayerAttacking) {
    final attackPos = Offset(
      attacker.position.dx + (isPlayerAttacking ? 30 : -30),
      attacker.position.dy + 5,
    );

    _fightActions.add(
      FightAction(
        actionType: attacker.animationState == MemberAnimationState.attacking
            ? 'punch'
            : 'hit',
        position: attackPos,
        color: Colors.white,
        size: 20 + _random.nextDouble() * 10,
        life: 20,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _actionTimer.cancel();
    _movementTimer.cancel();
    super.dispose();
  }

  void _addExplosion(Offset position, bool isGut) {
    int count = isGut ? 15 : 25;
    for (int i = 0; i < count; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 1.0 + _random.nextDouble() * 4.0;

      _particles.add(
        Particle(
          position: position,
          velocity: Offset(
            cos(angle) * speed,
            sin(angle) * speed - 2,
          ), // Upward bias
          size: isGut
              ? (4 + _random.nextDouble() * 6)
              : (2 + _random.nextDouble() * 5),
          opacity: 0.8 + _random.nextDouble() * 0.2,
          rotation: _random.nextDouble() * 2 * pi,
          rotationSpeed: (_random.nextDouble() - 0.5) * 0.5,
          color: isGut ? Colors.pink.shade300 : Colors.red.shade900,
          type: isGut && _random.nextDouble() > 0.6
              ? ParticleType.gut
              : ParticleType.blood,
          maxLife: 40 + _random.nextInt(30),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(FightAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.playerHealth < oldWidget.playerHealth) {
      final pos = Offset(
        40 + _random.nextDouble() * 60,
        100 + _random.nextDouble() * 50,
      );
      _addExplosion(pos, (oldWidget.playerHealth - widget.playerHealth) > 15);

      // Mark player members as dead if health is low
      final healthPerMember = widget.playerMaxHealth / widget.playerMembers;
      for (int i = 0; i < _playerMembers.length; i++) {
        if (widget.playerHealth <= i * healthPerMember) {
          _playerMembers[i].isAlive = false;
          _playerMembers[i].animationState = MemberAnimationState.dead;
        }
      }
    }
    if (widget.enemyHealth < oldWidget.enemyHealth) {
      final pos = Offset(
        MediaQuery.of(context).size.width - 140 + _random.nextDouble() * 60,
        100 + _random.nextDouble() * 50,
      );
      _addExplosion(pos, (oldWidget.enemyHealth - widget.enemyHealth) > 20);

      // Mark enemy members as dead if health is low
      final healthPerMember = widget.enemyMaxHealth / widget.enemyCount;
      for (int i = 0; i < _enemyMembers.length; i++) {
        if (widget.enemyHealth <= i * healthPerMember) {
          _enemyMembers[i].isAlive = false;
          _enemyMembers[i].animationState = MemberAnimationState.dead;
        }
      }
    }

    // Reinitialize members if count changed
    if (widget.playerMembers != oldWidget.playerMembers ||
        widget.enemyCount != oldWidget.enemyCount) {
      _initializeMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.brown.shade900,
        border: Border.all(color: Colors.brown.shade700, width: 4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Container(color: Colors.brown.shade900),
            CustomPaint(
              painter: BloodSplatterPainter(_particles),
              size: Size.infinite,
            ),
            // Draw player members
            ..._playerMembers.map((member) => _buildMemberWidget(member)),
            // Draw enemy members
            ..._enemyMembers.map((member) => _buildMemberWidget(member)),

            // Fight action effects
            ..._fightActions.map((action) => _buildFightAction(action)),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberWidget(GangMember member) {
    final isRanged = _isRangedWeapon();
    final isMoving =
        member.animationState == MemberAnimationState.walking ||
        member.animationState == MemberAnimationState.attacking;

    // Calculate position with walk animation
    Offset animatedPosition = member.position;
    if (member.animationState == MemberAnimationState.walking) {
      final walkOffset =
          (member.targetPosition - member.position) * member.walkProgress;
      animatedPosition = member.position + walkOffset;
    }

    // Calculate attack offset
    Offset attackOffset = Offset.zero;
    if (member.isAttacking) {
      final attackDirection = member.isPlayer ? 1.0 : -1.0;
      final attackDistance = isRanged
          ? 0.0
          : 20.0 * sin(member.attackProgress * pi);
      attackOffset = Offset(attackDirection * attackDistance, 0);
    }

    return Positioned(
      left: animatedPosition.dx + attackOffset.dx,
      top: animatedPosition.dy + attackOffset.dy,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weapon indicator
          if (member.isAlive && widget.currentWeapon != null)
            _buildWeaponIndicator(member.isPlayer, isRanged),
          // Member sprite
          Transform.translate(
            offset: Offset(
              0,
              isMoving ? sin(member.walkProgress * 4 * pi) * 2 : 0,
            ),
            child: PixelArtMember(
              isPlayer: member.isPlayer,
              isAlive: member.isAlive,
              isCheering:
                  (member.isPlayer && widget.enemyHealth <= 0) ||
                  (!member.isPlayer && widget.playerHealth <= 0),
              size: 30,
              enemyType: widget.enemyType,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponIndicator(bool isPlayer, bool isRanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          PixelArtIcon(
            name: _getSanitizedWeaponName(widget.currentWeapon!),
            size: 16,
          ),
          if (isRanged)
            Container(
              margin: const EdgeInsets.only(left: 2),
              width: 8,
              height: 3,
              color: Colors.orange,
            ),
        ],
      ),
    );
  }

  String _getSanitizedWeaponName(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pistol')) return 'pistol';
    if (lower.contains('uzi')) return 'uzi';
    if (lower.contains('ar15')) return 'ar15';
    if (lower.contains('sword')) return 'sword';
    if (lower.contains('bat')) return 'bat';
    if (lower.contains('grenade')) return 'grenade';
    if (lower.contains('knife')) return 'knife';
    return 'pistol';
  }

  Widget _buildFightAction(FightAction action) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = action.currentLife / action.life;
        final scale = 1.0 + (1.0 - opacity) * 0.5;

        return Positioned(
          left: action.position.dx,
          top: action.position.dy,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Text(
                action.actionType == 'shoot'
                    ? '💥'
                    : action.actionType == 'stab'
                    ? '🗡️'
                    : action.actionType == 'punch'
                    ? '👊'
                    : '💥',
                style: TextStyle(
                  fontSize: action.size,
                  color: action.color,
                  shadows: [
                    BoxShadow(
                      color: Colors.black.withAlpha(50),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
