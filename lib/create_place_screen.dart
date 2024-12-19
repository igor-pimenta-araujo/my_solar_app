import 'package:flutter/material.dart';
import 'services/api_service.dart';

class CreatePlaceScreen extends StatefulWidget {
  final String userId;

  CreatePlaceScreen({required this.userId});

  @override
  _CreatePlaceScreenState createState() => _CreatePlaceScreenState();
}

class _CreatePlaceScreenState extends State<CreatePlaceScreen> {
  final _placeNameController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  void _createPlace() async {
    if (_placeNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor, insira o nome do local")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await apiService.createPlace(_placeNameController.text, widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Local criado com sucesso!")),
      );
      Navigator.pop(context); // Volta para a tela anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Novo Local"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nome do Local:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _placeNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ex: Sala de estar",
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: isLoading ? null : _createPlace,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Criar Local"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
