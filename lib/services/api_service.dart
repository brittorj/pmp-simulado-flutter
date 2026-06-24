import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/questao.dart';

class ApiService {
  // Altere para o IP do seu servidor quando estiver em produção
  static const String baseUrl = 'http://10.0.2.2:3001'; // Android emulator
  // Para dispositivo físico, use: 'http://seu_ip_aqui:3001'

  // Buscar questões por módulo
  static Future<List<Questao>> fetchQuestoesPorModulo(String modulo) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/questoes?modulo=$modulo'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> questoesData = data['questoes'] ?? [];
        
        return questoesData
            .map((q) => Questao.fromJson(q))
            .toList();
      } else {
        throw Exception('Erro ao buscar questões: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      rethrow;
    }
  }

  // Buscar simulado misto
  static Future<List<Questao>> fetchSimuladoMisto({int quantidade = 50}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/questoes?tipo=misto&quantidade=$quantidade'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> questoesData = data['questoes'] ?? [];
        
        return questoesData
            .map((q) => Questao.fromJson(q))
            .toList();
      } else {
        throw Exception('Erro ao buscar simulado misto: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      rethrow;
    }
  }

  // Salvar resultado
  static Future<void> salvarResultado({
    required int moduloId,
    required String tipoSimulado,
    required int questoesRespondidas,
    required int acertos,
    required double percentual,
    required int tempoDecorrido,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/resultados'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'modulo_id': moduloId,
          'tipo_simulado': tipoSimulado,
          'questoes_respondidas': questoesRespondidas,
          'acertos': acertos,
          'percentual': percentual,
          'tempo_decorrido': tempoDecorrido,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Erro ao salvar resultado: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao salvar resultado: $e');
      // Não relança para não interromper o fluxo
    }
  }

  // Verificar versão
  static Future<Map<String, dynamic>> fetchVersion() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/version'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Erro ao buscar versão: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      rethrow;
    }
  }

  // Buscar módulos
  static Future<List<Map<String, dynamic>>> fetchModulos() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/modulos'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ao buscar módulos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
      rethrow;
    }
  }
}
