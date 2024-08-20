import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/temperature_service.dart';

// Global notification plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class TemperatureWidget extends StatefulWidget {
  @override
  _TemperatureWidgetState createState() => _TemperatureWidgetState();
}

class _TemperatureWidgetState extends State<TemperatureWidget> {
  double? _temperature;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchTemperature();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _fetchTemperature());
  }

  Future<void> _fetchTemperature() async {
    try {
      final temperature = await fetchTemperature();
      setState(() {
        _temperature = temperature;
      });

      if (temperature != null) {
        if (temperature > 30) {
          // Eğer sıcaklık 30°C'yi geçerse sesli bildirim yap
          await _playAlarmSound();
        } else if (temperature > 20) {
          // Eğer sıcaklık 20°C'yi geçerse bildirim yap
          await _showNotification('Sıcaklık Uyarısı', 'Sıcaklık $temperature°C oldu!');
        }
      }
    } catch (e) {
      print('Sıcaklık verisi alınamadı: $e');
    }
  }

  Future<void> _playAlarmSound() async {
    // Alarm sesini çalma kodu buraya eklenecek
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'temperature_channel_id',
      'Temperature Alerts',
      channelDescription: 'Channel for temperature alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _temperature == null
          ? CircularProgressIndicator()
          : Text('Sıcaklık: ${_temperature?.toStringAsFixed(1)}°C', style: TextStyle(fontSize: 24)),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
