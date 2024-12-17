import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class MqttService {
  late MqttServerClient client;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'solar_alerts',
      'Solar Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Alerta Solar',
      message,
      platformChannelSpecifics,
    );
  }

  Future<void> connect() async {
    // Initialize notifications first
    await initializeNotifications();

    // Existing MQTT setup code
    client = MqttServerClient('test.mosquitto.org', 'flutter_client');
    client.port = 1883;
    client.keepAlivePeriod = 30;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    client.connectionMessage = connMessage;

    try {
      print('Conectando ao broker MQTT...');
      await client.connect();
      print('Conectado!');

      client.subscribe('placa/alertas', MqttQos.atMostOnce);

      client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        print('Nova mensagem recebida: $payload');

        // Show notification when message is received
        showNotification(payload);
      });
    } catch (e) {
      print('Erro na conexão: $e');
      client.disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
    print('Desconectado do broker MQTT');
  }
}
