import 'package:flutter/material.dart';

class PlacaStatusScreen extends StatefulWidget {
  @override
  _PlacaStatusScreenState createState() => _PlacaStatusScreenState();
}

class _PlacaStatusScreenState extends State<PlacaStatusScreen> {
  bool isLoading = false;
  String statusPlaca = "Aguardando busca...";
  List<Map<String, String>> sensores = [];

  // Simulação da busca do status
  void buscarStatus() async {
    setState(() {
      isLoading = true;
      statusPlaca = "Atualizando status...";
    });

    // Simulando um tempo de resposta
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isLoading = false;
      statusPlaca = "Placa está funcionando corretamente.";
      sensores = [
        {"nome": "Sensor 1", "status": "Normal"},
        {"nome": "Sensor 2", "status": "Baixa produção"},
        {"nome": "Sensor 3", "status": "Normal"},
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Status da Placa Solar"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Painel principal
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Buscar Status da Placa",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Clique no botão abaixo para atualizar os dados da placa solar.",
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: buscarStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          minimumSize: Size(double.infinity, 48),
                        ),
                        child: isLoading
                            ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text("Buscar", style: TextStyle(color: Colors.grey[100])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Status da placa
            Text(
              "Status da Placa:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              statusPlaca,
              style: TextStyle(
                fontSize: 14,
                color: statusPlaca.contains("funcionando")
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
            SizedBox(height: 16),

            // Sensores
            Text(
              "Sensores:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sensores.length,
                itemBuilder: (context, index) {
                  final sensor = sensores[index];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        sensor['status'] == "Normal"
                            ? Icons.check_circle
                            : Icons.warning,
                        color: sensor['status'] == "Normal"
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(sensor['nome']!),
                      subtitle: Text("Status: ${sensor['status']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
