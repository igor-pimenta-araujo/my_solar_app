import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = "https://solar-5br1.onrender.com"; // Altere conforme necessário
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

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao fazer login: ${response.body}");
    }
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

  // Buscar locais do usuário
  Future<List<dynamic>> getPlaces(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/place/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return _processResponse(response);
  }

  // Adiciona o token automaticamente ao cabeçalho
  Future<Map<String, dynamic>> authenticatedRequest(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro na requisição: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final token = prefs.getString('accessToken');

    print('userId: $userId');
    print('token: $token');

    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro ao buscar dados do usuário: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetails(String placeId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  final response = await http.get(
    Uri.parse('$baseUrl/place/$placeId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Erro ao buscar detalhes do local: ${response.body}");
  }
}
}
