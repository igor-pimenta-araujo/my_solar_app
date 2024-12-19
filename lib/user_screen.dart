import 'package:flutter/material.dart';
import 'services/api_service.dart';

class UserScreen extends StatefulWidget {
  final String userId;

  UserScreen({required this.userId});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final ApiService apiService = ApiService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final data = await apiService.getUser(widget.userId);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar dados do usuário: $e")),
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
        title: Text("Perfil do Usuário"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userData == null
              ? Center(child: Text("Nenhum dado encontrado"))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome: ${userData!['name']}", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text("E-mail: ${userData!['email']}", style: TextStyle(fontSize: 18)),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}
