class MqttConfig {
  static const String broker = 'your.mqtt.broker.com';
  static const int port = 1883;  // or 8883 for SSL/TLS
  static const String username = 'your_username';
  static const String password = 'your_password';
  static const String clientId = 'flutter_client';
  static const String topic = 'placa/alertas';
  static const String baseUrl = 'http://localhost:3000';
}