import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_gym/models/employee_model.dart';

class EmployeesApi {
  static const String baseUrl = "http://26.199.102.50:3000/v1/employees";

  static Future<List<Employee>> getEmployees() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/getEmployees"));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception("Error al obtener empleados");
      }
    } catch (e) {
      print("Error en getEmployees: $e");
      return [];
    }
  }

  static Future<Employee?> createEmployee(Employee employee) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/createEmployee"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(employee.toJson()),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return Employee.fromJson(data);
      } else {
        throw Exception("Error al crear empleado");
      }
    } catch (e) {
      print("Error en createEmployee: $e");
      return null;
    }
  }

  static Future<bool> deleteEmployee(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/deleteEmployee/$id"));
      return res.statusCode == 200;
    } catch (e) {
      print("Error en deleteEmployee: $e");
      return false;
    }
  }

}
