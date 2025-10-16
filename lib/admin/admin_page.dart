import 'package:flutter/material.dart';
import 'package:flutter_application_gym/clients-section/ClientsPage.dart';
import 'package:flutter_application_gym/admin/admin_employees.dart';
import 'package:flutter_application_gym/admin/AdminPlansPage.dart';
import 'package:flutter_application_gym/admin/ClientStats.dart';
import 'package:flutter_application_gym/notifications-section/NotificationsPage.dart'; // 👈 Importación añadida

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String activeTab = "dashboard";

  final List<Map<String, dynamic>> menuItems = [
    {"id": "dashboard", "label": "Dashboard General", "icon": Icons.bar_chart},
    {"id": "appointments", "label": "Gestión de Citas", "icon": Icons.calendar_today},
    {"id": "payments", "label": "Pagos y Finanzas", "icon": Icons.credit_card},
    {"id": "clients", "label": "Gestión de Clientes", "icon": Icons.group},
    {"id": "machines", "label": "Gestión de Máquinas", "icon": Icons.fitness_center},
    {"id": "employees", "label": "Gestión de Empleados", "icon": Icons.verified_user},
    {"id": "plans", "label": "Planes y Membresías", "icon": Icons.airplane_ticket},
    {"id": "notifications", "label": "Centro de Notificaciones", "icon": Icons.notifications},
  ];

  Widget renderContent() {
    switch (activeTab) {
      case "appointments":
        return const Center(child: Text("AdminAppointments Widget"));
      case "payments":
        return const Center(child: Text("AdminPayments Widget"));
      case "clients":
        return ClientsPage();
      case "machines":
        return const Center(child: Text("AdminMachines Widget"));
      case "employees":
        return AdminEmployeesPage();
      case "plans":
        return AdminPlansPage();
      case "notifications":
        return NotificationsPage();
      case "dashboard":
      default:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Resumen del Gimnasio",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ClientStats(), // 👈 Aquí se muestra el componente de estadísticas
              SizedBox(height: 24),
              // Aquí podrías añadir más widgets como gráficos, alertas, KPIs, etc.
            ],
          ),
        );
    }
  }

  Widget buildSidebar() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: const BorderSide(color: Color.fromARGB(255, 226, 221, 221), width: 2.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              leading: Icon(Icons.shield, size: 20),
              title: Text("Panel de Control", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const Divider(height: 1),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: menuItems.map((item) {
                final bool isActive = activeTab == item["id"];
                return ListTile(
                  leading: Icon(
                    item["icon"],
                    color: isActive ? Color.fromARGB(255, 240, 161, 14) : Colors.grey,
                  ),
                  title: Text(
                    item["label"],
                    style: TextStyle(
                      color: isActive ? Color.fromARGB(255, 240, 161, 14) : Colors.black,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isActive,
                  onTap: () {
                    setState(() {
                      activeTab = item["id"];
                    });
                    Navigator.of(context).maybePop();
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 900;
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Panel de Administración", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                Text("Bienvenido, Administrador - Control Total del Gimnasio", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.black),
                onPressed: () {
                  // lógica de logout
                },
              )
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
                            side: const BorderSide(color: Color.fromARGB(255, 226, 221, 221), width: 2.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: renderContent(),
                          ),
                        ),
                      ),
                    ],
                  )
                : Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: renderContent(),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
