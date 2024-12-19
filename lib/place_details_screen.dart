import 'package:flutter/material.dart';
import 'services/api_service.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeId;
  final String placeName;

  PlaceDetailsScreen({required this.placeId, required this.placeName});

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? placeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlaceDetails();
  }

  Future<void> _fetchPlaceDetails() async {
    try {
      final data = await apiService.fetchPlaceDetails(widget.placeId);
      setState(() {
        placeData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar detalhes do local: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.placeName),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Ação ao clicar no ícone de notificação
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Notificações em breve!")),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildPlaceDetails(),
    );
  }

  Widget _buildPlaceDetails() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageSection(),
          _buildSensorSection(),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/place_placeholder.jpg'), // Substitua pela imagem do local
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(16.0),
        child: Text(
          widget.placeName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black87,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSensorSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sensores",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildSensorCard("Painéis Solares", placeData!['solarPanelSensors']),
          SizedBox(height: 10),
          _buildSensorCard("Temperatura", placeData!['temperatureSensors']),
          SizedBox(height: 10),
          _buildSensorCard("Luminosidade", placeData!['luminositySensors']),
          SizedBox(height: 10),
          _buildSensorCard("Nível de Sujeira", placeData!['dirtSensors']),
        ],
      ),
    );
  }

  Widget _buildSensorCard(String title, List<dynamic> sensors) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.orange),
          ),
          SizedBox(height: 10),
          sensors.isEmpty
              ? Text(
                  "Nenhum sensor cadastrado.",
                  style: TextStyle(color: Colors.white),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sensors.length,
                  itemBuilder: (context, index) {
                    final sensor = sensors[index];
                    return Text(
                      "- Sensor ID: ${sensor['id'] ?? 'N/A'}",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
