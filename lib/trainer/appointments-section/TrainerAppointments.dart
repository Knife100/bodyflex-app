import 'package:flutter/material.dart';

class TrainerAppointments extends StatefulWidget {
  const TrainerAppointments({super.key});

  @override
  State<TrainerAppointments> createState() => _TrainerAppointmentsState();
}

class _TrainerAppointmentsState extends State<TrainerAppointments> {
  String searchTerm = "";

  final List<Map<String, dynamic>> appointments = [
    {
      "id": 1,
      "client": "María González",
      "service": "Entrenamiento Personal",
      "date": "2024-01-20",
      "time": "09:00 AM",
      "status": "Confirmada",
      "phone": "+57 300 123 4567",
      "notes": "Primera sesión, enfoque en cardio",
    },
    {
      "id": 2,
      "client": "Carlos Rodríguez",
      "service": "Valoración Física",
      "date": "2024-01-20",
      "time": "11:00 AM",
      "status": "Pendiente",
      "phone": "+57 301 234 5678",
      "notes": "Cliente nuevo, evaluación completa",
    },
    {
      "id": 3,
      "client": "Ana Martínez",
      "service": "Clase Funcional",
      "date": "2024-01-20",
      "time": "03:00 PM",
      "status": "Confirmada",
      "phone": "+57 302 345 6789",
      "notes": "Clase grupal, 8 participantes",
    },
    {
      "id": 4,
      "client": "Luis Fernández",
      "service": "Entrenamiento Personal",
      "date": "2024-01-21",
      "time": "10:00 AM",
      "status": "Programada",
      "phone": "+57 303 456 7890",
      "notes": "Sesión de fuerza, piernas",
    },
  ];

  final List<String> clients = [
    "María González",
    "Carlos Rodríguez",
    "Ana Martínez",
    "Luis Fernández",
    "Pedro Sánchez",
    "Laura Torres",
    "Diego Morales",
  ];

  // Campos del formulario
  String? selectedClient;
  String? selectedService;
  String? selectedTime;
  String? notes;
  DateTime? selectedDate;

  void handleNewAppointment() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Cita agendada exitosamente")),
    );
  }

  void handleStatusChange(int id, String newStatus) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cita $id actualizada a: $newStatus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = appointments.where((a) {
      return a["client"].toLowerCase().contains(searchTerm.toLowerCase()) ||
          a["service"].toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: const Color.fromARGB(255, 250, 250, 250),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🔹 Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.calendar_month,
                          color: Color.fromARGB(255, 240, 161, 14)),
                      SizedBox(width: 8),
                      Text(
                        "Gestión de Citas",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 240, 161, 14),
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => _buildDialog(context),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text("Agendar Cita"),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Administra las citas de tus clientes",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Buscador
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Buscar por cliente o servicio...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (v) => setState(() => searchTerm = v),
              ),
              const SizedBox(height: 20),

              // 🔹 Lista de citas
              Column(
                children: filtered.map((a) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 243, 217, 141),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.event,
                            color: Color.fromARGB(255, 207, 138, 35),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(a["client"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(a["service"],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14),
                                  const SizedBox(width: 4),
                                  Text("${a["date"]} - ${a["time"]}"),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14),
                                  const SizedBox(width: 4),
                                  Text(a["phone"]),
                                ],
                              ),
                              if (a["notes"] != null)
                                Text(a["notes"],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          children: [
                            DropdownButton<String>(
                              value: a["status"],
                              items: const [
                                DropdownMenuItem(
                                    value: "Programada",
                                    child: Text("Programada")),
                                DropdownMenuItem(
                                    value: "Confirmada",
                                    child: Text("Confirmada")),
                                DropdownMenuItem(
                                    value: "Pendiente",
                                    child: Text("Pendiente")),
                                DropdownMenuItem(
                                    value: "Completada",
                                    child: Text("Completada")),
                                DropdownMenuItem(
                                    value: "Cancelada",
                                    child: Text("Cancelada")),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  handleStatusChange(a["id"], v);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {},
                              child: const Text("Editar"),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Agendar Nueva Cita"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Cliente"),
              items: clients
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => selectedClient = v,
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Servicio"),
              items: const [
                DropdownMenuItem(
                    value: "Entrenamiento Personal",
                    child: Text("Entrenamiento Personal")),
                DropdownMenuItem(
                    value: "Valoración Física",
                    child: Text("Valoración Física")),
                DropdownMenuItem(
                    value: "Clase Funcional", child: Text("Clase Funcional")),
                DropdownMenuItem(value: "TRX", child: Text("Clase TRX")),
                DropdownMenuItem(
                    value: "Nutrición", child: Text("Consulta Nutricional")),
              ],
              onChanged: (v) => selectedService = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Fecha"),
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Hora"),
              items: const [
                DropdownMenuItem(value: "8:00 AM", child: Text("8:00 AM")),
                DropdownMenuItem(value: "9:00 AM", child: Text("9:00 AM")),
                DropdownMenuItem(value: "10:00 AM", child: Text("10:00 AM")),
                DropdownMenuItem(value: "11:00 AM", child: Text("11:00 AM")),
                DropdownMenuItem(value: "2:00 PM", child: Text("2:00 PM")),
                DropdownMenuItem(value: "3:00 PM", child: Text("3:00 PM")),
                DropdownMenuItem(value: "4:00 PM", child: Text("4:00 PM")),
                DropdownMenuItem(value: "5:00 PM", child: Text("5:00 PM")),
              ],
              onChanged: (v) => selectedTime = v,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Notas adicionales"),
              onChanged: (v) => notes = v,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: handleNewAppointment,
          style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 240, 161, 14)),
          child: const Text("Agendar Cita"),
        ),
      ],
    );
  }
}
