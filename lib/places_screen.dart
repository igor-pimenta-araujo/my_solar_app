import 'package:flutter/material.dart';
import 'services/api_service.dart';

class PlacesScreen extends StatefulWidget {
  final String userId;

  PlacesScreen({required this.userId});

  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  final ApiService apiService = ApiService();
  List<dynamic>? places;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  void _loadPlaces() async {
    try {
      final data = await apiService.getPlaces(widget.userId);
      setState(() {
        places = data;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar locais: $e")),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Locais"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : places == null || places!.isEmpty
              ? Center(child: Text("Nenhum local encontrado"))
              : ListView.builder(
                  itemCount: places!.length,
                  itemBuilder: (context, index) {
                    final place = places![index];
                    return Card(
                      child: ListTile(
                        title: Text(place['name']),
                        subtitle: Text("ID: ${place['id']}"),
                      ),
                    );
                  },
                ),
    );
  }
}
