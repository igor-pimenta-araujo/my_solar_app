import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  // Simulação de dados das placas solares
  final List<Map<String, dynamic>> placas = [
    {"id": 1, "nome": "Placa 1", "local": "Sala de Estar", "cor": Colors.blue},
    {"id": 2, "nome": "Placa 2", "local": "Escritório", "cor": Colors.red},
    {"id": 3, "nome": "Placa 3", "local": "Quarto", "cor": Colors.green},
    {"id": 4, "nome": "Placa 4", "local": "Cozinha", "cor": Colors.yellow},
    {"id": 5, "nome": "Placa 5", "local": "Suíte", "cor": Colors.teal},
    {"id": 6, "nome": "Placa 6", "local": "Varanda", "cor": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Ação de configuração
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: placas.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final placa = placas[index];
            return GestureDetector(
              onTap: () {
                // Navega para a tela de detalhes da placa
                Navigator.pushNamed(context, '/placa-status');
              },
              child: Card(
                color: placa['cor'],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.solar_power,
                        size: 40,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        placa['local'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.wifi, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class DetalhesPlacaScreen extends StatelessWidget {
  final Map<String, dynamic> placa;

  DetalhesPlacaScreen({required this.placa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(placa['local']),
      ),
      body: Center(
        child: Text(
          "Detalhes da ${placa['nome']}",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
