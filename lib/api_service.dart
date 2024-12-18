import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:3000"; // Altere conforme necessário
  String? token;

  ApiService({this.token});

  // Método POST para Criar Usuário
  Future<dynamic> createUser(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"name": name, "email": email, "password": password}),
    );
    return _processResponse(response);
  }

  // Método POST para Login
  Future<dynamic> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = _processResponse(response);
    token = data['token']; // Salva o token para requisições autenticadas
    return data;
  }

  // Método GET para Buscar Usuário
  Future<dynamic> getUser(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return _processResponse(response);
  }

  // Método POST para Criar Place
  Future<dynamic> createPlace(String name, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/place'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({"name": name, "userId": userId}),
    );
    return _processResponse(response);
  }

  // Método POST para Inserir Dados do Sensor
  Future<dynamic> insertSensorData(String sensorType, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/sensor/data/$sensorType'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(data),
    );
    return _processResponse(response);
  }

  // Método Privado para Processar Resposta
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro: ${response.statusCode} - ${response.body}");
    }
  }
}
