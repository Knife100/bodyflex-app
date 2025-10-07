import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_application_gym/models/client_model.dart';

class ClientsApi {
  static const String baseUrl = "http://26.199.102.50:3000/v1/clients";

  // Obtener todos los clientes
  static Future<List<Client>> getClients() async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/getClients"));
      if (res.statusCode == 200) {
        print(res.body);
        final List<dynamic> data = jsonDecode(res.body);
        return data.map((e) => Client.fromJson(e)).toList();
      } else {
        throw Exception("Error al obtener clientes");
      }
    } catch (e) {
      print("Error en getClients: $e");
      return [];
    }
  }

  // Obtener cliente por ID
  static Future<Client?> getClientById(int id) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/showClient/$id"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Client.fromJson(data);
      } else {
        throw Exception("Error al obtener cliente");
      }
    } catch (e) {
      print("Error en getClientById: $e");
      return null;
    }
  }

  // Crear cliente
  static Future<Client?> createClient(Client client) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/createClient"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(client.toJson()),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return Client.fromJson(data);
      } else {
        throw Exception("Error al crear cliente");
      }
    } catch (e) {
      print("Error en createClient: $e");
      return null;
    }
  }

  // Actualizar cliente
  static Future<Client?> updateClient(int id, Client client) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/updateClient/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(client.toJson()),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return Client.fromJson(data);
      } else {
        throw Exception("Error al actualizar cliente");
      }
    } catch (e) {
      print("Error en updateClient: $e");
      return null;
    }
  }

  // Eliminar cliente
  static Future<bool> deleteClient(int id) async {
    try {
      final res = await http.delete(Uri.parse("$baseUrl/deleteClient/$id"));
      if (res.statusCode == 200) {
        return true;
      } else {
        throw Exception("Error al eliminar cliente");
      }
    } catch (e) {
      print("Error en deleteClient: $e");
      return false;
    }
  }
}
