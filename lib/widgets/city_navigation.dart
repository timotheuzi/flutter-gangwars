import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_button.dart';

class CityNavigation extends StatefulWidget {
  const CityNavigation({super.key});

  @override
  CityNavigationState createState() => CityNavigationState();
}

class CityNavigationState extends State<CityNavigation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  double _dragStartX = 0;
  double _dragStartY = 0;
  double _cameraOffsetX = 0;
  double _cameraOffsetY = 0;
  double _zoomLevel = 1.0;

  bool _isDragging = false;
  bool _isZooming = false;
  bool _showingBuildingInfo = false;
  String _currentBuildingInfo = '';

  // Building positions and data
  final List<BuildingData> _buildings = [
    BuildingData(
      name: 'Crackhouse',
      type: 'crackhouse',
      x: 100,
      y: 200,
      description: 'Buy and sell drugs',
      color: Colors.green,
      icon: Icons.local_pharmacy,
    ),
    BuildingData(
      name: 'Gun Shack',
      type: 'gunshack',
      x: 400,
      y: 150,
      description: 'Purchase weapons',
      color: Colors.red,
      icon: Icons.security,
    ),
    BuildingData(
      name: 'Bank',
      type: 'bank',
      x: 250,
      y: 350,
      description: 'Manage finances',
      color: Colors.blue,
      icon: Icons.account_balance,
    ),
    BuildingData(
      name: 'Bar',
      type: 'bar',
      x: 500,
      y: 300,
      description: 'Gather information',
      color: Colors.amber,
      icon: Icons.local_bar,
    ),
    BuildingData(
      name: 'Info Booth',
      type: 'infobooth',
      x: 150,
      y: 450,
      description: 'Special items',
      color: Colors.purple,
      icon: Icons.info,
    ),
    BuildingData(
      name: 'Alleyway',
      type: 'alleyway',
      x: 600,
      y: 200,
      description: 'Explore hidden areas',
      color: Colors.grey,
      icon: Icons.explore,
    ),
    BuildingData(
      name: 'Pick n Save',
      type: 'picknsave',
      x: 350,
      y: 500,
      description: 'Gang management',
      color: Colors.orange,
      icon: Icons.shopping_cart,
    ),
    BuildingData(
      name: 'Credits',
      type: 'credits',
      x: 700,
      y: 400,
      description: 'Game information',
      color: Colors.teal,
      icon: Icons.credit_card,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Navigation - Touch to Move'),
        actions: [
          IconButton(icon: const Icon(Icons.zoom_in), onPressed: _zoomIn),
          IconButton(icon: const Icon(Icons.zoom_out), onPressed: _zoomOut),
          IconButton(
            icon: const Icon(Icons.center_focus_strong),
            onPressed: _centerView,
          ),
        ],
      ),
      body: Stack(
        children: [
          // City Map Background
          _buildCityMap(),

          // Building Labels
          ..._buildBuildingLabels(),

          // Touch Controls Overlay
          _buildTouchControls(),

          // Building Info Popup
          if (_showingBuildingInfo) _buildBuildingInfo(),

          // Navigation Instructions
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Drag to move • Pinch to zoom • Tap buildings',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityMap() {
    return GestureDetector(
      onPanStart: (details) {
        _isDragging = true;
        _dragStartX = details.globalPosition.dx;
        _dragStartY = details.globalPosition.dy;
      },
      onPanUpdate: (details) {
        if (_isDragging) {
          final deltaX = details.globalPosition.dx - _dragStartX;
          final deltaY = details.globalPosition.dy - _dragStartY;

          setState(() {
            _cameraOffsetX += deltaX;
            _cameraOffsetY += deltaY;
            _dragStartX = details.globalPosition.dx;
            _dragStartY = details.globalPosition.dy;
          });
        }
      },
      onPanEnd: (details) {
        _isDragging = false;
      },
      onScaleStart: (details) {
        _isZooming = true;
      },
      onScaleUpdate: (details) {
        if (_isZooming) {
          setState(() {
            _zoomLevel = details.scale.clamp(0.5, 3.0);
          });
        }
      },
      onScaleEnd: (details) {
        _isZooming = false;
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade700,
              Colors.purple.shade600,
            ],
          ),
        ),
        child: CustomPaint(
          painter: CityMapPainter(
            buildings: _buildings,
            cameraOffsetX: _cameraOffsetX,
            cameraOffsetY: _cameraOffsetY,
            zoomLevel: _zoomLevel,
          ),
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }

  List<Widget> _buildBuildingLabels() {
    return _buildings.map((building) {
      final screenCenterX = MediaQuery.of(context).size.width / 2;
      final screenCenterY = MediaQuery.of(context).size.height / 2;

      final adjustedX =
          screenCenterX + (building.x * _zoomLevel) + _cameraOffsetX;
      final adjustedY =
          screenCenterY + (building.y * _zoomLevel) + _cameraOffsetY;

      return Positioned(
        left: adjustedX - 40,
        top: adjustedY - 80,
        child: GestureDetector(
          onTap: () => _showBuildingInfo(building),
          onDoubleTap: () => _navigateToBuilding(building),
          child: Transform.scale(
            scale: _zoomLevel,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: building.color.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Column(
                    children: [
                      Icon(building.icon, color: Colors.white, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        building.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    building.description,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTouchControls() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GameButton(
            text: 'Move Left',
            onPressed: () => _moveCamera(-50, 0),
            icon: Icons.arrow_left,
            backgroundColor: Colors.blue,
          ),
          GameButton(
            text: 'Move Up',
            onPressed: () => _moveCamera(0, -50),
            icon: Icons.arrow_upward,
            backgroundColor: Colors.blue,
          ),
          GameButton(
            text: 'Move Down',
            onPressed: () => _moveCamera(0, 50),
            icon: Icons.arrow_downward,
            backgroundColor: Colors.blue,
          ),
          GameButton(
            text: 'Move Right',
            onPressed: () => _moveCamera(50, 0),
            icon: Icons.arrow_right,
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildBuildingInfo() {
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentBuildingInfo.split('\n').first,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _currentBuildingInfo.split('\n').skip(1).join('\n'),
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GameButton(
                    text: 'Enter',
                    onPressed: () {
                      final building = _buildings.firstWhere(
                        (b) => b.name == _currentBuildingInfo.split('\n').first,
                      );
                      _navigateToBuilding(building);
                    },
                    icon: Icons.login,
                    backgroundColor: Colors.green,
                  ),
                  GameButton(
                    text: 'Close',
                    onPressed: () {
                      setState(() {
                        _showingBuildingInfo = false;
                        _currentBuildingInfo = '';
                      });
                    },
                    icon: Icons.close,
                    backgroundColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBuildingInfo(BuildingData building) {
    setState(() {
      _showingBuildingInfo = true;
      _currentBuildingInfo =
          '${building.name}\n${building.description}\n\nTap Enter to go inside';
    });
  }

  void _navigateToBuilding(BuildingData building) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.navigateToScreen(building.type);
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel * 1.2).clamp(0.5, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel / 1.2).clamp(0.5, 3.0);
    });
  }

  void _centerView() {
    setState(() {
      _cameraOffsetX = 0;
      _cameraOffsetY = 0;
      _zoomLevel = 1.0;
    });
  }

  void _moveCamera(double dx, double dy) {
    setState(() {
      _cameraOffsetX += dx;
      _cameraOffsetY += dy;
    });
  }
}

class BuildingData {
  final String name;
  final String type;
  final double x;
  final double y;
  final String description;
  final Color color;
  final IconData icon;

  BuildingData({
    required this.name,
    required this.type,
    required this.x,
    required this.y,
    required this.description,
    required this.color,
    required this.icon,
  });
}

class CityMapPainter extends CustomPainter {
  final List<BuildingData> buildings;
  final double cameraOffsetX;
  final double cameraOffsetY;
  final double zoomLevel;

  CityMapPainter({
    required this.buildings,
    required this.cameraOffsetX,
    required this.cameraOffsetY,
    required this.zoomLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw city grid
    paint.color = Colors.grey.shade800.withValues(alpha: 0.8);
    for (int x = -1000; x < 1000; x += 100) {
      canvas.drawLine(
        Offset(
          x * zoomLevel + cameraOffsetX,
          -1000 * zoomLevel + cameraOffsetY,
        ),
        Offset(x * zoomLevel + cameraOffsetX, 1000 * zoomLevel + cameraOffsetY),
        paint..strokeWidth = 1,
      );
    }
    for (int y = -1000; y < 1000; y += 100) {
      canvas.drawLine(
        Offset(
          -1000 * zoomLevel + cameraOffsetX,
          y * zoomLevel + cameraOffsetY,
        ),
        Offset(1000 * zoomLevel + cameraOffsetX, y * zoomLevel + cameraOffsetY),
        paint..strokeWidth = 1,
      );
    }

    // Draw buildings
    for (final building in buildings) {
      final centerX = size.width / 2 + building.x * zoomLevel + cameraOffsetX;
      final centerY = size.height / 2 + building.y * zoomLevel + cameraOffsetY;

      // Building base
      paint.color = building.color.withValues(alpha: 0.8);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: 60 * zoomLevel,
          height: 80 * zoomLevel,
        ),
        paint,
      );

      // Building roof
      paint.color = building.color.withValues(alpha: 1.0);
      final path = Path();
      path.moveTo(centerX - 40 * zoomLevel, centerY - 40 * zoomLevel);
      path.lineTo(centerX + 40 * zoomLevel, centerY - 40 * zoomLevel);
      path.lineTo(centerX, centerY - 80 * zoomLevel);
      path.close();
      canvas.drawPath(path, paint);

      // Building door
      paint.color = Colors.black;
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, centerY + 20 * zoomLevel),
          width: 20 * zoomLevel,
          height: 30 * zoomLevel,
        ),
        paint,
      );

      // Building sign
      final textSpan = TextSpan(
        text: building.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12 * zoomLevel,
          fontWeight: FontWeight.bold,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(centerX - textPainter.width / 2, centerY - 60 * zoomLevel),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CityMapPainter oldDelegate) =>
      oldDelegate.cameraOffsetX != cameraOffsetX ||
      oldDelegate.cameraOffsetY != cameraOffsetY ||
      oldDelegate.zoomLevel != zoomLevel ||
      oldDelegate.buildings.length != buildings.length;
}
