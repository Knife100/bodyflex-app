import 'package:flutter/material.dart';

class TrainerPayments extends StatefulWidget {
  const TrainerPayments({super.key});

  @override
  State<TrainerPayments> createState() => _TrainerPaymentsState();
}

class _TrainerPaymentsState extends State<TrainerPayments> {
  bool isDialogOpen = false;
  String searchTerm = "";
  String? selectedPlan;

  final List<Map<String, dynamic>> payments = [
    {
      "id": "PAY-001",
      "client": "María González",
      "amount": "\$99.000",
      "plan": "MENSUALIDAD",
      "method": "Efectivo",
      "date": "2024-01-20",
      "status": "Completado",
      "registeredBy": "Carlos Mendoza",
    },
    {
      "id": "PAY-002",
      "client": "Luis Fernández",
      "amount": "\$160.000",
      "plan": "COMBO 2 AFILIADO",
      "method": "Tarjeta",
      "date": "2024-01-19",
      "status": "Completado",
      "registeredBy": "Carlos Mendoza",
    },
    {
      "id": "PAY-003",
      "client": "Ana Martínez",
      "amount": "\$50.000",
      "plan": "PLAN PREMIUM BÁSICO",
      "method": "Transferencia",
      "date": "2024-01-18",
      "status": "Pendiente",
      "registeredBy": "Carlos Mendoza",
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

  final List<Map<String, String>> plans = [
    {"name": "MENSUALIDAD", "price": "99.000"},
    {"name": "COMBO 2 AFILIADO", "price": "160.000"},
    {"name": "COMBO 3 AFILIADO", "price": "199.000"},
    {"name": "COMBO 2x3", "price": "199.000"},
    {"name": "PLAN PREMIUM BÁSICO", "price": "50.000"},
    {"name": "PLAN PLATINUM PLUS", "price": "120.000"},
  ];

  void handleNewPayment() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pago registrado exitosamente")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPayments = payments.where((p) {
      return p['client'].toLowerCase().contains(searchTerm.toLowerCase()) ||
          p['plan'].toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header con botón ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.credit_card,
                      color: Color.fromARGB(255, 240, 161, 14), size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Registro de Pagos",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 207, 138, 35),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => _buildPaymentDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text("Registrar Pago"),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Registra y gestiona los pagos de los clientes",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // --- Buscador ---
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Buscar por cliente o plan...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: (value) => setState(() => searchTerm = value),
          ),
          const SizedBox(height: 20),

          // --- Lista de pagos ---
          ...filteredPayments.map((payment) => Card(
                color: const Color.fromARGB(255, 250, 250, 250),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 2,
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
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 243, 217, 141),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.credit_card,
                                color: Color.fromARGB(255, 207, 138, 35)),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payment['client'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              Text("${payment['plan']} • ${payment['method']}",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              Text(
                                "${payment['date']} • Registrado por: ${payment['registeredBy']}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // --- Monto y estado ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(payment['amount'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: payment['status'] == "Completado"
                                  ? Colors.green
                                  : Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(payment['status'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // --- Diálogo para registrar nuevo pago ---
  Widget _buildPaymentDialog() {
    return AlertDialog(
      title: const Text("Registrar Nuevo Pago"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Cliente"),
              items: clients
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (_) {},
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Plan de Membresía"),
              items: plans
                  .map((p) => DropdownMenuItem(
                        value: p['name'],
                        child: Text("${p['name']} - \$${p['price']}"),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => selectedPlan = val),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Monto"),
              readOnly: true,
              controller: TextEditingController(
                text: selectedPlan != null
                    ? "\$${plans.firstWhere((p) => p['name'] == selectedPlan)['price']}"
                    : "",
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Método de Pago"),
              items: const [
                DropdownMenuItem(value: "efectivo", child: Text("Efectivo")),
                DropdownMenuItem(value: "tarjeta", child: Text("Tarjeta")),
                DropdownMenuItem(
                    value: "transferencia", child: Text("Transferencia")),
                DropdownMenuItem(value: "nequi", child: Text("Nequi")),
              ],
              onChanged: (_) {},
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Fecha de Pago"),
              keyboardType: TextInputType.datetime,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Notas (opcional)"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar")),
        ElevatedButton(
            onPressed: handleNewPayment, child: const Text("Registrar")),
      ],
    );
  }
}


  

