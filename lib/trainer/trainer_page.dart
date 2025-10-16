import 'package:flutter/material.dart';
import 'package:flutter_application_gym/clients-section/ClientsPage.dart';
import 'package:flutter_application_gym/trainer/appointments-section/TrainerAppointments.dart';
import 'package:flutter_application_gym/trainer/clients-section/TrainerClients.dart';
import 'package:flutter_application_gym/trainer/clients-section/TrainerClientsPage.dart';
import 'package:flutter_application_gym/notifications-section/NotificationsPage.dart';
import 'package:flutter_application_gym/trainer/payments-section/TrainerPayments.dart';
import 'package:flutter_application_gym/trainer/trainer_stats.dart'; // ✅ Import del módulo de estadísticas


class TrainerDashboard extends StatefulWidget {
  const TrainerDashboard({super.key});

  @override
  State<TrainerDashboard> createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  String activeTab = "dashboard";

  final List<Map<String, dynamic>> menuItems = [
    {"id": "dashboard", "label": "Dashboard General", "icon": Icons.dashboard},
    {"id": "appointments", "label": "Mis Citas", "icon": Icons.calendar_today},
    {"id": "payments", "label": "Pagos", "icon": Icons.credit_card},
    {"id": "clients", "label": "Gestión de Clientes", "icon": Icons.people},
    {
      "id": "notifications",
      "label": "Notificaciones",
      "icon": Icons.notifications
    },
    {"id": "workout", "label": "Mapa del Gimnasio", "icon": Icons.map},
    {"id": "timer", "label": "Cronómetro", "icon": Icons.timer},
    {"id": "progress", "label": "Mi Progreso", "icon": Icons.bar_chart},
  ];

  /// Muestra el contenido de cada pestaña
  Widget renderContent() {
    switch (activeTab) {
      case "appointments":
        return TrainerAppointments();
      case "payments":
        return TrainerPayments();
      case "clients":
        return TrainerClientsPage();
      case "notifications":
        return NotificationsPage();
      case "workout":
        return const Center(child: Text("Mapa del Gimnasio"));
      case "timer":
        return const Center(child: Text("Cronómetro"));
      case "progress":
        return const Center(child: Text("Dashboard de Progreso"));
      default:
        return TrainerStats(onTabChange: (tab) => setState(() => activeTab = tab));
    }
  }

  /// Construcción del panel lateral (sidebar)
  Widget buildSidebar() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(
          color: Color.fromARGB(255, 226, 221, 221),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.sports_gymnastics, size: 20),
              title: Text(
                "Panel del Entrenador",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            ...menuItems.map((item) {
              final bool isActive = activeTab == item["id"];
              return ListTile(
                leading: Icon(
                  item["icon"],
                  color: isActive
                      ? const Color.fromARGB(255, 240, 161, 14)
                      : Colors.grey,
                ),
                title: Text(
                  item["label"],
                  style: TextStyle(
                    color: isActive
                        ? const Color.fromARGB(255, 240, 161, 14)
                        : Colors.black,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  setState(() => activeTab = item["id"]);
                  Navigator.of(context).maybePop(); // Para cerrar el drawer en móviles
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Estructura principal del dashboard
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      bool isDesktop = constraints.maxWidth > 900;

      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Portal de Entrenadores",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                "Bienvenido, Carlos Mendoza",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        drawer: isDesktop ? null : Drawer(child: buildSidebar()),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: buildSidebar()),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 226, 221, 221),
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: renderContent(), // ✅ Aquí el contenido dinámico
                        ),
                      ),
                    ),
                  ],
                )
              : Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: renderContent(), // ✅ También en móviles
                  ),
                ),
        ),
      );
    });
  }
}
