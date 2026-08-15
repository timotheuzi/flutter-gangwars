import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'procedural_pixel_art.dart';

/// Procedural Pixel Art Renderer
/// Displays procedurally generated pixel art with animations

class ProceduralRenderer extends StatefulWidget {
  final ProceduralPixelArt generator;
  final int pixelSize;
  final bool showGrid;
  final Color gridColor;

  const ProceduralRenderer({
    super.key,
    required this.generator,
    this.pixelSize = 4,
    this.showGrid = true,
    this.gridColor = Colors.black12,
  });

  @override
  ProceduralRendererState createState() => ProceduralRendererState();
}

class ProceduralRendererState extends State<ProceduralRenderer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ProceduralCharacter _character;
  late ProceduralBuilding _building;
  late ProceduralWeapon _weapon;
  late ProceduralEnvironment _environment;
  late ProceduralVehicle _vehicle;

  @override
  void initState() {
    super.initState();

    // Initialize procedural generation
    _character = widget.generator.generateCharacter(
      type: CharacterType.gangster,
      variant: 1,
    );

    _building = widget.generator.generateBuilding(
      type: BuildingType.crackhouse,
      variant: 1,
    );

    _weapon = widget.generator.generateWeapon(
      type: WeaponType.pistol,
      variant: 1,
    );

    _environment = widget.generator.generateEnvironment(
      type: EnvironmentType.city,
      variant: 1,
    );

    _vehicle = widget.generator.generateVehicle(
      type: VehicleType.car,
      variant: 1,
    );

    // Setup animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Procedural Pixel Art Renderer'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _regenerateAll,
          ),
          IconButton(icon: const Icon(Icons.save), onPressed: _saveScreenshot),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Character Section
              const Text(
                'Characters',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildCharacterGrid(),

              const SizedBox(height: 30),

              // Building Section
              const Text(
                'Buildings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildBuildingGrid(),

              const SizedBox(height: 30),

              // Weapon Section
              const Text(
                'Weapons',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildWeaponGrid(),

              const SizedBox(height: 30),

              // Environment Section
              const Text(
                'Environments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildEnvironmentGrid(),

              const SizedBox(height: 30),

              // Vehicle Section
              const Text(
                'Vehicles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildVehicleGrid(),

              const SizedBox(height: 30),

              // Interactive Demo
              const Text(
                'Interactive Demo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildInteractiveDemo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 1.0,
      children: [
        _buildCharacterCard(CharacterType.gangster, 'Gangster'),
        _buildCharacterCard(CharacterType.dealer, 'Dealer'),
        _buildCharacterCard(CharacterType.prostitute, 'Prostitute'),
        _buildCharacterCard(CharacterType.victim, 'Victim'),
        _buildCharacterCard(CharacterType.police, 'Police'),
      ],
    );
  }

  Widget _buildBuildingGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: [
        _buildBuildingCard(BuildingType.crackhouse, 'Crackhouse'),
        _buildBuildingCard(BuildingType.gunshack, 'Gun Shack'),
        _buildBuildingCard(BuildingType.bank, 'Bank'),
        _buildBuildingCard(BuildingType.bar, 'Bar'),
        _buildBuildingCard(BuildingType.alleyway, 'Alleyway'),
      ],
    );
  }

  Widget _buildWeaponGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      children: [
        _buildWeaponCard(WeaponType.pistol, 'Pistol'),
        _buildWeaponCard(WeaponType.uzi, 'Uzi'),
        _buildWeaponCard(WeaponType.knife, 'Knife'),
        _buildWeaponCard(WeaponType.bat, 'Bat'),
      ],
    );
  }

  Widget _buildEnvironmentGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 2.0,
      children: [
        _buildEnvironmentCard(EnvironmentType.city, 'City'),
        _buildEnvironmentCard(EnvironmentType.alley, 'Alley'),
        _buildEnvironmentCard(EnvironmentType.street, 'Street'),
      ],
    );
  }

  Widget _buildVehicleGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      children: [
        _buildVehicleCard(VehicleType.car, 'Car'),
        _buildVehicleCard(VehicleType.motorcycle, 'Motorcycle'),
        _buildVehicleCard(VehicleType.truck, 'Truck'),
      ],
    );
  }

  Widget _buildCharacterCard(CharacterType type, String name) {
    final character = widget.generator.generateCharacter(type: type);
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _showCharacterDetail(character, name),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              _buildPixelArt(character.pixels),
              const SizedBox(height: 5),
              _buildAnimationPreview(character.animations.first),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBuildingCard(BuildingType type, String name) {
    final building = widget.generator.generateBuilding(type: type);
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _showBuildingDetail(building, name),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              _buildPixelArt(building.pixels),
              const SizedBox(height: 5),
              _buildAnimationPreview(building.animations.first),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeaponCard(WeaponType type, String name) {
    final weapon = widget.generator.generateWeapon(type: type);
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _showWeaponDetail(weapon, name),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              _buildPixelArt(weapon.pixels),
              const SizedBox(height: 5),
              _buildAnimationPreview(weapon.animations.first),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard(EnvironmentType type, String name) {
    final environment = widget.generator.generateEnvironment(type: type);
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _showEnvironmentDetail(environment, name),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              _buildPixelArt(environment.pixels),
              const SizedBox(height: 5),
              _buildParallaxPreview(environment.parallaxLayers),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(VehicleType type, String name) {
    final vehicle = widget.generator.generateVehicle(type: type);
    return Card(
      color: Colors.grey[900],
      child: InkWell(
        onTap: () => _showVehicleDetail(vehicle, name),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(name, style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 5),
              _buildPixelArt(vehicle.pixels),
              const SizedBox(height: 5),
              _buildAnimationPreview(vehicle.animations.first),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveDemo() {
    return Card(
      color: Colors.grey[900],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton('Randomize', _regenerateAll),
                _buildControlButton(
                  'Walk',
                  () => _playAnimation(AnimationType.walk),
                ),
                _buildControlButton(
                  'Action',
                  () => _playAnimation(AnimationType.action),
                ),
                _buildControlButton(
                  'Idle',
                  () => _playAnimation(AnimationType.idle),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPixelArt(_character.pixels),
                _buildPixelArt(_building.pixels),
                _buildPixelArt(_weapon.pixels),
              ],
            ),
            const SizedBox(height: 20),
            _buildEnvironmentDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _buildPixelArt(List<List<Color>> pixels) {
    return CustomPaint(
      size: Size(
        pixels[0].length * widget.pixelSize.toDouble(),
        pixels.length * widget.pixelSize.toDouble(),
      ),
      painter: PixelArtPainter(
        pixels: pixels,
        pixelSize: widget.pixelSize,
        showGrid: widget.showGrid,
        gridColor: widget.gridColor,
      ),
    );
  }

  Widget _buildAnimationPreview(ProceduralAnimation animation) {
    return SizedBox(
      width: 64,
      height: 64,
      child: CustomPaint(
        painter: AnimationPreviewPainter(
          animation: animation,
          pixelSize: widget.pixelSize,
          showGrid: widget.showGrid,
          gridColor: widget.gridColor,
          controller: _controller,
        ),
      ),
    );
  }

  Widget _buildParallaxPreview(List<ParallaxLayer> layers) {
    return SizedBox(
      width: 128,
      height: 64,
      child: CustomPaint(
        painter: ParallaxPreviewPainter(
          layers: layers,
          pixelSize: widget.pixelSize,
          showGrid: widget.showGrid,
          gridColor: widget.gridColor,
          controller: _controller,
        ),
      ),
    );
  }

  Widget _buildEnvironmentDemo() {
    return SizedBox(
      width: 300,
      height: 150,
      child: CustomPaint(
        painter: EnvironmentDemoPainter(
          environment: _environment,
          character: _character,
          vehicle: _vehicle,
          pixelSize: widget.pixelSize,
          showGrid: widget.showGrid,
          gridColor: widget.gridColor,
          controller: _controller,
        ),
      ),
    );
  }

  void _regenerateAll() {
    setState(() {
      _character = widget.generator.generateCharacter(
        type: CharacterType.gangster,
        variant: _randomVariant(),
      );

      _building = widget.generator.generateBuilding(
        type: BuildingType.crackhouse,
        variant: _randomVariant(),
      );

      _weapon = widget.generator.generateWeapon(
        type: WeaponType.pistol,
        variant: _randomVariant(),
      );

      _environment = widget.generator.generateEnvironment(
        type: EnvironmentType.city,
        variant: _randomVariant(),
      );

      _vehicle = widget.generator.generateVehicle(
        type: VehicleType.car,
        variant: _randomVariant(),
      );
    });
  }

  void _playAnimation(AnimationType type) {
    // Trigger animation preview
    _controller.reset();
    _controller.forward();
  }

  void _showCharacterDetail(ProceduralCharacter character, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPixelArt(character.pixels),
            const SizedBox(height: 20),
            Text(
              'Variant: ${character.variant}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Color Scheme: ${character.colorScheme.primary}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showBuildingDetail(ProceduralBuilding building, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPixelArt(building.pixels),
            const SizedBox(height: 20),
            Text(
              'Variant: ${building.variant}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showWeaponDetail(ProceduralWeapon weapon, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPixelArt(weapon.pixels),
            const SizedBox(height: 20),
            Text(
              'Variant: ${weapon.variant}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEnvironmentDetail(ProceduralEnvironment environment, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPixelArt(environment.pixels),
            const SizedBox(height: 20),
            Text(
              'Variant: ${environment.variant}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Parallax Layers: ${environment.parallaxLayers.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showVehicleDetail(ProceduralVehicle vehicle, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(name, style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPixelArt(vehicle.pixels),
            const SizedBox(height: 20),
            Text(
              'Variant: ${vehicle.variant}',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _saveScreenshot() {
    // This would require platform channels or other methods to save the rendered image
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Screenshot functionality would be implemented with platform channels',
        ),
      ),
    );
  }

  int _randomVariant() => DateTime.now().millisecondsSinceEpoch % 8;
}

// Custom painters for rendering

class PixelArtPainter extends CustomPainter {
  final List<List<Color>> pixels;
  final int pixelSize;
  final bool showGrid;
  final Color gridColor;

  PixelArtPainter({
    required this.pixels,
    required this.pixelSize,
    required this.showGrid,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (int y = 0; y < pixels.length; y++) {
      for (int x = 0; x < pixels[y].length; x++) {
        if (pixels[y][x] != Colors.transparent) {
          paint.color = pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    if (showGrid) {
      paint.color = gridColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;

      for (int y = 0; y <= pixels.length; y++) {
        canvas.drawLine(
          Offset(0, y * pixelSize.toDouble()),
          Offset(
            pixels[0].length * pixelSize.toDouble(),
            y * pixelSize.toDouble(),
          ),
          paint,
        );
      }

      for (int x = 0; x <= pixels[0].length; x++) {
        canvas.drawLine(
          Offset(x * pixelSize.toDouble(), 0),
          Offset(
            x * pixelSize.toDouble(),
            pixels.length * pixelSize.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PixelArtPainter oldDelegate) =>
      oldDelegate.pixels != pixels ||
      oldDelegate.pixelSize != pixelSize ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.gridColor != gridColor;
}

class AnimationPreviewPainter extends CustomPainter {
  final ProceduralAnimation animation;
  final int pixelSize;
  final bool showGrid;
  final Color gridColor;
  final AnimationController controller;

  AnimationPreviewPainter({
    required this.animation,
    required this.pixelSize,
    required this.showGrid,
    required this.gridColor,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final frameIndex =
        (controller.value * animation.frames.length).floor() %
        animation.frames.length;
    final frame = animation.frames[frameIndex];

    final paint = Paint();

    for (int y = 0; y < frame.length; y++) {
      for (int x = 0; x < frame[y].length; x++) {
        if (frame[y][x] != Colors.transparent) {
          paint.color = frame[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    if (showGrid) {
      paint.color = gridColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;

      for (int y = 0; y <= frame.length; y++) {
        canvas.drawLine(
          Offset(0, y * pixelSize.toDouble()),
          Offset(
            frame[0].length * pixelSize.toDouble(),
            y * pixelSize.toDouble(),
          ),
          paint,
        );
      }

      for (int x = 0; x <= frame[0].length; x++) {
        canvas.drawLine(
          Offset(x * pixelSize.toDouble(), 0),
          Offset(x * pixelSize.toDouble(), frame.length * pixelSize.toDouble()),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant AnimationPreviewPainter oldDelegate) =>
      oldDelegate.animation != animation ||
      oldDelegate.pixelSize != pixelSize ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.controller != controller;
}

class ParallaxPreviewPainter extends CustomPainter {
  final List<ParallaxLayer> layers;
  final int pixelSize;
  final bool showGrid;
  final Color gridColor;
  final AnimationController controller;

  ParallaxPreviewPainter({
    required this.layers,
    required this.pixelSize,
    required this.showGrid,
    required this.gridColor,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Sort layers by z-index
    final sortedLayers = List.from(layers)
      ..sort((a, b) => a.zIndex.compareTo(b.zIndex));

    for (final layer in sortedLayers) {
      final offsetX =
          (controller.value * 100 * layer.speed).floor() %
          layer.pixels[0].length;

      for (int y = 0; y < layer.pixels.length; y++) {
        for (int x = 0; x < layer.pixels[y].length; x++) {
          if (layer.pixels[y][x] != Colors.transparent) {
            paint.color = layer.pixels[y][x];
            canvas.drawRect(
              Rect.fromLTWH(
                ((x - offsetX) % layer.pixels[0].length) * pixelSize.toDouble(),
                y * pixelSize.toDouble(),
                pixelSize.toDouble(),
                pixelSize.toDouble(),
              ),
              paint,
            );
          }
        }
      }
    }

    if (showGrid) {
      paint.color = gridColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;

      for (int y = 0; y <= layers.first.pixels.length; y++) {
        canvas.drawLine(
          Offset(0, y * pixelSize.toDouble()),
          Offset(
            layers.first.pixels[0].length * pixelSize.toDouble(),
            y * pixelSize.toDouble(),
          ),
          paint,
        );
      }

      for (int x = 0; x <= layers.first.pixels[0].length; x++) {
        canvas.drawLine(
          Offset(x * pixelSize.toDouble(), 0),
          Offset(
            x * pixelSize.toDouble(),
            layers.first.pixels.length * pixelSize.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant ParallaxPreviewPainter oldDelegate) =>
      oldDelegate.layers != layers ||
      oldDelegate.pixelSize != pixelSize ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.controller != controller;
}

class EnvironmentDemoPainter extends CustomPainter {
  final ProceduralEnvironment environment;
  final ProceduralCharacter character;
  final ProceduralVehicle vehicle;
  final int pixelSize;
  final bool showGrid;
  final Color gridColor;
  final AnimationController controller;

  EnvironmentDemoPainter({
    required this.environment,
    required this.character,
    required this.vehicle,
    required this.pixelSize,
    required this.showGrid,
    required this.gridColor,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw environment background
    for (int y = 0; y < environment.pixels.length; y++) {
      for (int x = 0; x < environment.pixels[y].length; x++) {
        if (environment.pixels[y][x] != Colors.transparent) {
          paint.color = environment.pixels[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              x * pixelSize.toDouble(),
              y * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    // Draw character with animation
    final charFrameIndex =
        (controller.value * character.animations.first.frames.length).floor() %
        character.animations.first.frames.length;
    final charFrame = character.animations.first.frames[charFrameIndex];
    final charOffsetX =
        (controller.value * 50).floor() %
        (environment.pixels[0].length - charFrame[0].length);
    final charOffsetY = environment.pixels.length - charFrame.length - 2;

    for (int y = 0; y < charFrame.length; y++) {
      for (int x = 0; x < charFrame[y].length; x++) {
        if (charFrame[y][x] != Colors.transparent) {
          paint.color = charFrame[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              (charOffsetX + x) * pixelSize.toDouble(),
              (charOffsetY + y) * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    // Draw vehicle with animation
    final vehicleFrameIndex =
        (controller.value * vehicle.animations.first.frames.length).floor() %
        vehicle.animations.first.frames.length;
    final vehicleFrame = vehicle.animations.first.frames[vehicleFrameIndex];
    final vehicleOffsetX =
        (controller.value * 100).floor() %
        (environment.pixels[0].length - vehicleFrame[0].length);
    final vehicleOffsetY = environment.pixels.length - vehicleFrame.length;

    for (int y = 0; y < vehicleFrame.length; y++) {
      for (int x = 0; x < vehicleFrame[y].length; x++) {
        if (vehicleFrame[y][x] != Colors.transparent) {
          paint.color = vehicleFrame[y][x];
          canvas.drawRect(
            Rect.fromLTWH(
              (vehicleOffsetX + x) * pixelSize.toDouble(),
              (vehicleOffsetY + y) * pixelSize.toDouble(),
              pixelSize.toDouble(),
              pixelSize.toDouble(),
            ),
            paint,
          );
        }
      }
    }

    if (showGrid) {
      paint.color = gridColor;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;

      for (int y = 0; y <= environment.pixels.length; y++) {
        canvas.drawLine(
          Offset(0, y * pixelSize.toDouble()),
          Offset(
            environment.pixels[0].length * pixelSize.toDouble(),
            y * pixelSize.toDouble(),
          ),
          paint,
        );
      }

      for (int x = 0; x <= environment.pixels[0].length; x++) {
        canvas.drawLine(
          Offset(x * pixelSize.toDouble(), 0),
          Offset(
            x * pixelSize.toDouble(),
            environment.pixels.length * pixelSize.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant EnvironmentDemoPainter oldDelegate) =>
      oldDelegate.environment != environment ||
      oldDelegate.character != character ||
      oldDelegate.vehicle != vehicle ||
      oldDelegate.pixelSize != pixelSize ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.gridColor != gridColor ||
      oldDelegate.controller != controller;
}
