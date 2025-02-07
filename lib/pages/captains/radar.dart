import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RadarPage extends StatefulWidget {
  @override
  _RadarPageState createState() => _RadarPageState();
}

class _RadarPageState extends State<RadarPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double currentAngle = 0; // Angle of the radar sweep
  List<Offset> detectedObjects = []; // Store detected object positions
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..addListener(() {
        setState(() {
          currentAngle = _controller.value * pi; // Update angle during sweep
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();

    // Listen for data changes in Firebase
    _database.child("radar").onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        final angle = (data['angle'] ?? 0).toDouble();
        final distance = (data['distance'] ?? 0).toDouble();

        // Add detected object position only if distance < 20
        if (distance < 20) {
          addDetectedObject(distance, angle);
        }

        // Trigger repaint
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void addDetectedObject(double distance, double angleDegrees) {
    final angle = angleDegrees * pi / 180; // Convert to radians
    final double x = distance * cos(angle);
    final double y = -distance * sin(angle); // Invert y-axis for proper orientation

    setState(() {
      detectedObjects.add(Offset(x, y));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('180° Radar Interface'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: RadarPainter(currentAngle, detectedObjects),
            size: Size(400, 400),
          ),
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double angle; // Current angle of the radar sweep
  final List<Offset> objects; // List of detected object positions
  final double maxRadius = 200; // Maximum radius of the radar

  RadarPainter(this.angle, this.objects);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..style = PaintingStyle.stroke;

    final Paint sweepPaint = Paint()
      ..color = Colors.green.withOpacity(0.8)
      ..strokeWidth = 2.0;

    final Paint objectPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height); // Radar center
    final radius = min(size.width / 2, size.height); // Adjust radius

    // Draw radar arcs and lines
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(center, radius * i / 3, gridPaint);
    }

    for (int i = 30; i <= 150; i += 30) {
      final x = center.dx + radius * cos(i * pi / 180);
      final y = center.dy - radius * sin(i * pi / 180);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // Draw radar sweep line
    final sweepX = center.dx + radius * cos(angle);
    final sweepY = center.dy - radius * sin(angle);
    canvas.drawLine(center, Offset(sweepX, sweepY), sweepPaint);

    // Draw detected objects only when distance < 20
    for (final object in objects) {
      final objectPos = Offset(
        center.dx + object.dx,
        center.dy + object.dy,
      );
      canvas.drawCircle(objectPos, 5, objectPaint); // Red dots for objects
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
