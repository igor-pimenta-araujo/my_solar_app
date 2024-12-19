import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _mqttIpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMqttIp();
  }

  Future<void> _loadMqttIp() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('mqttIp') ?? '';
    setState(() {
      _mqttIpController.text = savedIp;
    });
  }

  Future<void> _saveMqttIp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mqttIp', _mqttIpController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("IP do MQTT salvo com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _mqttIpController,
              decoration: InputDecoration(
                labelText: "IP do MQTT",
                hintText: "Digite o IP do servidor MQTT",
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveMqttIp,
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
