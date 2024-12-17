import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Simulação de dados da API
  final List locais = [
    {
      "id": 1,
      "nome": "Local 1",
      "placas": [
        {"id": 101, "nome": "Placa Solar 1", "status": "Produzindo", "producao": "500W"},
        {"id": 102, "nome": "Placa Solar 2", "status": "Parada", "producao": "0W"}
      ]
    },
    {
      "id": 2,
      "nome": "Local 2",
      "placas": [
        {"id": 201, "nome": "Placa Solar 3", "status": "Produzindo", "producao": "750W"}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel Geral'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: locais.length,
        itemBuilder: (context, index) {
          final local = locais[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ExpansionTile(
              title: Text(local['nome'], style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                ...local['placas'].map((placa) {
                  return ListTile(
                    title: Text(placa['nome']),
                    subtitle: Text('Status: ${placa['status']}'),
                    trailing: Text(
                      'Produção: ${placa['producao']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
