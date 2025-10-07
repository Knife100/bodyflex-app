import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';

class PlanApi {
  static const String _baseUrl = 'http://26.199.102.50:3000/v1/plans';

  // Obtener todos los planes
  static Future<List<PlanFromAPI>> getPlans() async {
    try {
      final res = await http.get(Uri.parse('$_baseUrl/getPlans'));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((json) => PlanFromAPI.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener planes');
      }
    } catch (e) {
      print('Error en getPlans: $e');
      return [];
    }
  }

  // Crear un nuevo plan
  static Future<bool> createPlan(PlanPayload plan) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/createPlan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(plan.toJson()),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        throw Exception('Error al crear plan');
      }
    } catch (e) {
      print('Error en createPlan: $e');
      return false;
    }
  }

  // Actualizar plan existente
  static Future<bool> updatePlan(int id, PlanPayload plan) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/updatePlan/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(plan.toJson()),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al actualizar plan');
      }
    } catch (e) {
      print('Error en updatePlan: $e');
      return false;
    }
  }

  // Eliminar un plan
  static Future<bool> deletePlan(int id) async {
    try {
      final res = await http.delete(Uri.parse('$_baseUrl/deletePlan/$id'));

      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception('Error al eliminar plan');
      }
    } catch (e) {
      print('Error en deletePlan: $e');
      return false;
    }
  }
}
