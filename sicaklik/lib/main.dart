import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sicaklik/services/temperature_service.dart';
import 'package:workmanager/workmanager.dart';
import 'temperature_widget.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    double? temperature = await fetchTemperature(); // Bu metodun gerçek işleyişi, uygun şekilde uyarlanmalıdır.

    if (temperature != null) {
      if (temperature > 30) {
        // Sıcaklık 30°C'yi geçerse sesli bildirim yapın
      } else if (temperature > 20) {
        await flutterLocalNotificationsPlugin.show(
          0,
          'Sıcaklık Uyarısı',
          'Sıcaklık $temperature°C oldu!',
          NotificationDetails(
            android: AndroidNotificationDetails(
              'temperature_channel_id',
              'Temperature Alerts',
              channelDescription: 'Channel for temperature alerts',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    }
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sıcaklık Verisi'),
        ),
        body: TemperatureWidget(),
      ),
    );
  }
}
