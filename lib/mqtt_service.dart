import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class MqttService {
  late MqttServerClient client;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  MqttService() {
    _initializeNotifications();
  }

  // Inicializar notificações locais
  void _initializeNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // Ícone na pasta android/app/src/main/res/drawable
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Exibir notificação local
  void _showNotification(String message) async {
    print(message);
    const androidDetails = AndroidNotificationDetails(
      'test_channel', // ID do canal
      'Test Notifications', // Nome do canal
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // ID da notificação
      'Teste de Notificação', // Título
      'Esta é uma notificação de teste.', // Corpo
      notificationDetails,
    );
  }

  // Conectar ao MQTT
  Future<void> connect() async {
    final prefs = await SharedPreferences.getInstance();
    final mqttIp = prefs.getString('mqttIp') ?? '127.0.0.1'; // IP padrão
    print('IP do MQTT: $mqttIp');

    client = MqttServerClient(mqttIp, 'flutter_client');

    client.port = 1883;
    client.keepAlivePeriod = 20;
    client.logging(on: true);

    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? messages) {
      print('Mensagem recebida: $messages');
      final recMessage = messages?[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);

      print('Mensagem recebida: $payload');
      // Parse o payload como JSON e exibe notificação
      try {
        print('Igor Payload: $payload');
        final data = payload.contains("{") ? jsonDecode(payload) : {};
        final message = data['payload'] ?? 'Mensagem não encontrada';
        _showNotification(message);
      } catch (e) {
        print('Erro ao processar a mensagem: $e');
      }
    });

    try {
      await client.connect();
    } on Exception catch (e) {
      print('Erro ao conectar ao MQTT: $e');
      client.disconnect();
    }
  }

  void onConnected() {
    print('Conectado ao MQTT');
  }

  void onDisconnected() {
    print('Desconectado do MQTT');
  }

  void onSubscribed(String topic) {
    print('Inscrito no tópico: $topic');
  }

  Future<void> subscribeToTopic(String topic) async {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.subscribe(topic, MqttQos.atLeastOnce);
    } else {
      print('Não conectado ao MQTT.');
    }
  }

  void publish(String topic, String message) {
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    } else {
      print('Não conectado ao MQTT.');
    }
  }
}
