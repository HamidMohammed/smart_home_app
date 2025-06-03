import 'package:flutter/material.dart';
import 'dart:math';

class EnvironmentData {
  final double temperature;
  final double humidity;
  final bool gasLeak;

  const EnvironmentData({
    required this.temperature,
    required this.humidity,
    required this.gasLeak,
  });

  factory EnvironmentData.empty() => const EnvironmentData(
        temperature: 0,
        humidity: 0,
        gasLeak: false,
      );
}

class EnvironmentService {
  Stream<EnvironmentData> get stream async* {
    // Replace with your actual data stream
    while (true) {
      await Future.delayed(const Duration(seconds: 2));
      yield EnvironmentData(
        temperature: 10 + Random().nextDouble() * 20, // 20-30°C
        humidity: 10 + Random().nextDouble() * 80, // 30-80%
        gasLeak: Random().nextDouble() > 0.9, // 10% chance
      );
    }
  }
}

class GasAlertBanner extends StatelessWidget {
  const GasAlertBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.red[900],
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.warning, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(
            'GAS LEAK DETECTED!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class SensorStatusBar extends StatelessWidget {
  final double temperature;
  final double humidity;

  const SensorStatusBar({
    super.key,
    required this.temperature,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSensorItem(
              icon: Icons.thermostat,
              value: '${temperature.toStringAsFixed(1)}°C',
              color: _getTemperatureColor(temperature),
            ),
            _buildSensorItem(
              icon: Icons.water_drop,
              value: '${humidity.toStringAsFixed(0)}%',
              color: _getHumidityColor(humidity),
            ),
            _buildSensorItem(
              icon: Icons.check_circle,
              value: 'Air OK',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorItem({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 15) return Colors.blue;
    if (temp > 30) return Colors.red;
    return Colors.orange;
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.blue[300]!;
    if (humidity > 70) return Colors.green;
    return Colors.blue;
  }
}

class EnvironmentSensorTile extends StatelessWidget {
  final double temperature;
  final double humidity;
  final bool gasLeak;

  const EnvironmentSensorTile({
    super.key,
    required this.temperature,
    required this.humidity,
    required this.gasLeak,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ENVIRONMENT',
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 10),
              _buildSensorRow(
                icon: Icons.thermostat,
                value: '${temperature.toStringAsFixed(1)}°C',
                color: _getTemperatureColor(temperature),
              ),
              _buildSensorRow(
                icon: Icons.water_drop,
                value: '${humidity.toStringAsFixed(0)}%',
                color: _getHumidityColor(humidity),
              ),
              _buildSensorRow(
                icon: gasLeak ? Icons.warning : Icons.check_circle,
                value: gasLeak ? 'GAS LEAK!' : 'Air Safe',
                color: gasLeak ? Colors.red : Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorRow({
    required IconData icon,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 15),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 15) return Colors.blue;
    if (temp > 30) return Colors.red;
    return Colors.orange;
  }

  Color _getHumidityColor(double humidity) {
    if (humidity < 30) return Colors.blue[300]!;
    if (humidity > 70) return Colors.green;
    return Colors.blue;
  }
}
