import 'package:flutter/material.dart';
import 'pixel_art_location.dart';

class LocationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const LocationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          children: [
            // LARGE Background Icon/Illustration
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: PixelArtLocation(location: title, size: 150),
              ),
            ),
            
            // Gradient Overlay for text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),

            // Text Content (At the bottom)
            Positioned(
              bottom: 10,
              left: 8,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900, // Fixed: Changed from FontWeight.black to FontWeight.w900
                      color: Colors.white,
                      fontFamily: 'Courier',
                      shadows: [Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2))],
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
