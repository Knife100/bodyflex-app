import 'package:flutter/material.dart';

class TrainerStats extends StatelessWidget {
  final void Function(String) onTabChange;
  const TrainerStats({Key? key, required this.onTabChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Citas de Hoy",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildAppointmentsCard(),
            const SizedBox(height: 24),

            // Distribución adaptable
            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildRecentActivityCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildQuickActions()),
                    ],
                  )
                : Column(
                    children: [
                      _buildRecentActivityCard(),
                      const SizedBox(height: 16),
                      _buildQuickActions(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentsCard() {
    final appointments = [
      {
        "client": "María González",
        "service": "Entrenamiento Personal",
        "time": "09:00 AM",
        "status": "Confirmada"
      },
      {
        "client": "Carlos Rodríguez",
        "service": "Valoración Física",
        "time": "11:00 AM",
        "status": "Pendiente"
      },
      {
        "client": "Ana Martínez",
        "service": "Clase Funcional",
        "time": "03:00 PM",
        "status": "Confirmada"
      },
    ];

    return Card(
      color: const Color.fromARGB(255, 247, 247, 247),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: appointments.map((a) {
            final isConfirmed = (a['status'] as String) == "Confirmada";
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isConfirmed ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color:
                        isConfirmed ? Colors.green[100]! : Colors.orange[100]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a['client'] as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14)),
                        const SizedBox(height: 2),
                        Text("${a['service']} - ${a['time']}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isConfirmed ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(a['status'] as String,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    final activities = [
      {
        "icon": Icons.person_add,
        "color": Colors.blue,
        "title": "Nuevo cliente",
        "desc": "Pedro Sánchez - Plan Premium"
      },
      {
        "icon": Icons.attach_money,
        "color": Colors.green,
        "title": "Pago recibido",
        "desc": "María González - \$99.000"
      },
      {
        "icon": Icons.notifications,
        "color": Colors.amber,
        "title": "Notificación enviada",
        "desc": "15 usuarios recordados"
      },
    ];

    return Card(
      color: const Color.fromARGB(255, 247, 247, 247),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Actividad Reciente",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...activities.map((a) => ListTile(
                  leading: CircleAvatar(
                    backgroundColor: (a['color'] as Color).withOpacity(0.15),
                    child: Icon(a['icon'] as IconData,
                        color: a['color'] as Color, size: 20),
                  ),
                  title: Text(a['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(a['desc'] as String,
                      style: const TextStyle(color: Colors.grey)),
                  contentPadding: EdgeInsets.zero,
                )),
          ],
        ),
      ),
    );
  }

  // Nota: Los quick actions llaman a onTabChange(thisTab).
  Widget _buildQuickActions() {
    // definimos tabs iguales a los ids en TrainerDashboard
    final actions = [
      {"label": "Nuevo Cliente", "icon": Icons.person_add, "tab": "clients"},
      {"label": "Registrar Pago", "icon": Icons.credit_card, "tab": "payments"},
      {
        "label": "Agendar Cita",
        "icon": Icons.calendar_today,
        "tab": "appointments"
      },
      {
        "label": "Notificación",
        "icon": Icons.notifications,
        "tab": "notifications"
      },
    ];

    return Card(
      color: const Color.fromARGB(255, 247, 247, 247),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // 👈 Alinea el título a la izquierda
          children: [
            const Text(
              "Acciones rápidas", // 👈 Título de la tarjeta
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12), // 👈 Espacio entre título y grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: actions.map((a) {
                return GestureDetector(
                  onTap: () => onTabChange(a['tab'] as String),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(a['icon'] as IconData,
                            size: 30, color: const Color(0xFFF1C227)),
                        const SizedBox(height: 8),
                        Text(
                          a['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
