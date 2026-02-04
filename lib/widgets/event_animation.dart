import 'package:flutter/material.dart';
import 'dart:math';
import '../models/random_event.dart';
import 'pixel_art_member.dart';
import 'pixel_art_icon.dart';

class EventAnimation extends StatefulWidget {
  final RandomEvent event;
  final String? selectedOption;

  const EventAnimation({super.key, required this.event, this.selectedOption});

  @override
  State<EventAnimation> createState() => _EventAnimationState();
}

class _EventAnimationState extends State<EventAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border.all(color: Colors.grey.shade800, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Dark Alley Background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.grey.shade900],
                  ),
                ),
              ),
            ),

            // Animation content based on event type
            _buildAnimationLayer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationLayer() {
    switch (widget.event.type) {
      case EventType.moneyFound:
        return _buildMoneyFoundAnimation();
      case EventType.healthRestore:
        return _buildHealthAnimation();
      case EventType.weaponFound:
        return _buildWeaponAnimation();
      case EventType.trap:
        return _buildTrapAnimation();
      case EventType.npcEncounter:
        return _buildNpcAnimation();
      case EventType.drugDeal:
        return _buildDrugDealAnimation();
      default:
        return _buildDefaultAnimation();
    }
  }

  Widget _buildMoneyFoundAnimation() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -20 * _controller.value),
                child: Opacity(
                  opacity: 1 - _controller.value,
                  child: const Text('💰', style: TextStyle(fontSize: 40)),
                ),
              );
            },
          ),
          const PixelArtMember(
            isPlayer: true,
            isAlive: true,
            isCheering: true,
            size: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthAnimation() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PixelArtMember(isPlayer: true, isAlive: true, size: 40),
          const SizedBox(width: 20),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (sin(_controller.value * 2 * pi) * 0.2),
                child: const Icon(Icons.favorite, color: Colors.red, size: 40),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeaponAnimation() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PixelArtMember(isPlayer: true, isAlive: true, size: 40),
          const SizedBox(width: 20),
          const PixelArtIcon(name: 'pistol', size: 40),
        ],
      ),
    );
  }

  Widget _buildTrapAnimation() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          const PixelArtMember(isPlayer: true, isAlive: true, size: 40),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: sin(_controller.value * 10 * pi).abs(),
                child: const Text('💥🩸', style: TextStyle(fontSize: 30)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNpcAnimation() {
    final isFighting = widget.selectedOption == 'Fight' ||
        widget.selectedOption == 'Challenge';
    final isRecruiting = widget.selectedOption == 'Recruit';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PixelArtMember(
          isPlayer: true,
          isAlive: true,
          isCheering: isRecruiting,
          size: 40,
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (isFighting) {
              return const Text('⚔️', style: TextStyle(fontSize: 30));
            }
            return const Text('💬', style: TextStyle(fontSize: 24));
          },
        ),
        PixelArtMember(
          isPlayer: false,
          isAlive: !isFighting || _controller.value < 0.5,
          isCheering: isRecruiting,
          size: 40,
        ),
      ],
    );
  }

  Widget _buildDrugDealAnimation() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PixelArtMember(isPlayer: true, isAlive: true, size: 40),
          const SizedBox(width: 10),
          const Text('🤝', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          const PixelArtIcon(name: 'crack', size: 40),
        ],
      ),
    );
  }

  Widget _buildDefaultAnimation() {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(sin(_controller.value * 2 * pi) * 50, 0),
            child: const PixelArtMember(
              isPlayer: true,
              isAlive: true,
              size: 40,
            ),
          );
        },
      ),
    );
  }
}
