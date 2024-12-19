import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void _login() async {
    try {
      final response = await apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      // Salvar accessToken e userId no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', response['accessToken']);
      await prefs.setString('userId', response['userId']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')));

      // Redirecionar para a dashboard
      Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao fazer login: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "E-mail"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Senha"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Entrar"),
            ),
          ],
        ),
      ),
    );
  }
}
