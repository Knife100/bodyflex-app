import 'package:flutter/material.dart';

class TrainerClients extends StatefulWidget {
  const TrainerClients({Key? key}) : super(key: key);

  @override
  State<TrainerClients> createState() => _TrainerClientsState();
}

class _TrainerClientsState extends State<TrainerClients> {
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> clients = [
    {
      "id": 1,
      "name": "María González",
      "email": "maria.gonzalez@email.com",
      "phone": "+57 300 123 4567",
      "plan": "MENSUALIDAD",
      "status": "Activo",
      "joinDate": "2024-01-15",
      "lastVisit": "2024-01-20",
      "trainer": "Carlos Mendoza",
    },
    {
      "id": 2,
      "name": "Luis Fernández",
      "email": "luis.fernandez@email.com",
      "phone": "+57 301 234 5678",
      "plan": "COMBO 2 AFILIADO",
      "status": "Activo",
      "joinDate": "2024-01-10",
      "lastVisit": "2024-01-19",
      "trainer": "Carlos Mendoza",
    },
    {
      "id": 3,
      "name": "Ana Martínez",
      "email": "ana.martinez@email.com",
      "phone": "+57 302 345 6789",
      "plan": "PLAN PREMIUM BÁSICO",
      "status": "Pendiente",
      "joinDate": "2024-01-18",
      "lastVisit": "2024-01-18",
      "trainer": "Carlos Mendoza",
    },
    {
      "id": 4,
      "name": "Pedro Sánchez",
      "email": "pedro.sanchez@email.com",
      "phone": "+57 303 456 7890",
      "plan": "COMBO 3 AFILIADO",
      "status": "Activo",
      "joinDate": "2024-01-12",
      "lastVisit": "2024-01-20",
      "trainer": "Carlos Mendoza",
    },
  ];

  final List<String> plans = [
    "MENSUALIDAD",
    "COMBO 2 AFILIADO",
    "COMBO 3 AFILIADO",
    "COMBO 2x3",
    "PLAN PREMIUM BÁSICO",
    "PLAN PLATINUM PLUS"
  ];

  List<Map<String, dynamic>> get filteredClients {
    final query = searchController.text.toLowerCase();
    return clients.where((c) {
      return c["name"].toLowerCase().contains(query) ||
          c["email"].toLowerCase().contains(query) ||
          c["plan"].toLowerCase().contains(query);
    }).toList();
  }

  void _showNewClientDialog() {
    final TextEditingController nameCtrl = TextEditingController();
    final TextEditingController emailCtrl = TextEditingController();
    final TextEditingController phoneCtrl = TextEditingController();
    final TextEditingController dateCtrl = TextEditingController();
    final TextEditingController notesCtrl = TextEditingController();
    String? selectedPlan;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registrar Nuevo Cliente"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(nameCtrl, "Nombre Completo", Icons.person),
              const SizedBox(height: 10),
              _buildTextField(emailCtrl, "Correo Electrónico", Icons.email,
                  type: TextInputType.emailAddress),
              const SizedBox(height: 10),
              _buildTextField(phoneCtrl, "Teléfono", Icons.phone,
                  type: TextInputType.phone),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Plan de Membresía",
                  border: OutlineInputBorder(),
                ),
                initialValue: selectedPlan,
                items: plans
                    .map((p) =>
                        DropdownMenuItem(value: p, child: Text(p.toString())))
                    .toList(),
                onChanged: (v) => selectedPlan = v,
              ),
              const SizedBox(height: 10),
              _buildTextField(dateCtrl, "Fecha de Ingreso", Icons.calendar_today,
                  type: TextInputType.datetime),
              const SizedBox(height: 10),
              _buildTextField(notesCtrl, "Notas (opcional)", Icons.note),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancelar")),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Cliente registrado exitosamente")));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  foregroundColor: Colors.white),
              child: const Text("Registrar Cliente")),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {TextInputType? type}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---- ENCABEZADO ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.people, color: Colors.black87),
                        SizedBox(width: 8),
                        Text("Gestión de Clientes",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text("Administra la información de tus clientes",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showNewClientDialog,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white),
                  icon: const Icon(Icons.person_add),
                  label: const Text("Nuevo Cliente"),
                )
              ],
            ),
            const SizedBox(height: 20),

            // ---- BUSCADOR ----
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Buscar por nombre, email o plan...",
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),

            // ---- LISTA DE CLIENTES ----
            ...filteredClients.map((client) {
              final bool isActive = client["status"] == "Activo";
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // --- Info del cliente ---
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(Icons.person,
                                color: Colors.green, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(client["name"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.email, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(client["email"],
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(client["phone"],
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                      "Ingreso: ${client["joinDate"]} • Última visita: ${client["lastVisit"]}",
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // --- Plan y estado ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(client["plan"],
                                style: const TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green[500]
                                  : Colors.amber[600],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(client["status"],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit, size: 16),
                            label: const Text("Editar"),
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
