import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String selectedType = "";
  bool sendToAll = false;
  List<String> selectedClients = [];

  final ScrollController _clientListController = ScrollController();

  @override
  void dispose() {
    _clientListController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> notificationTypes = [
    {
      "value": "appointment",
      "label": "Recordatorio de Cita",
      "icon": Icons.calendar_today,
      "color": Colors.blue
    },
    {
      "value": "payment",
      "label": "Recordatorio de Pago",
      "icon": Icons.credit_card,
      "color": Colors.amber
    },
    {
      "value": "achievement",
      "label": "Logro/Felicitación",
      "icon": Icons.emoji_events,
      "color": Colors.green
    },
    {
      "value": "system",
      "label": "Información del Sistema",
      "icon": Icons.error_outline,
      "color": Colors.red
    },
    {
      "value": "promotion",
      "label": "Promoción Especial",
      "icon": Icons.notifications,
      "color": Colors.purple
    },
  ];

  final List<Map<String, dynamic>> sentNotifications = [
    {
      "id": 1,
      "title": "Recordatorio de Cita",
      "message": "Recordatorio: Tienes una cita mañana a las 10:00 AM",
      "type": "appointment",
      "recipients": 5,
      "date": "2024-01-20",
      "status": "Enviada",
    },
    {
      "id": 2,
      "title": "Promoción Especial",
      "message":
          "¡Aprovecha nuestra promoción de enero! 20% de descuento en planes anuales",
      "type": "promotion",
      "recipients": 45,
      "date": "2024-01-18",
      "status": "Enviada",
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

  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  void _handleSendNotification() {
    final recipients = sendToAll
        ? "todos los clientes"
        : "${selectedClients.length} clientes seleccionados";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notificación enviada a $recipients"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
    setState(() {
      selectedClients.clear();
      sendToAll = false;
      selectedType = "";
      _titleController.clear();
      _messageController.clear();
    });
  }

  void _openNotificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Crear Nueva Notificación",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        // Tipo
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: "Tipo de Notificación",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedType.isNotEmpty ? selectedType : null,
                          items: notificationTypes
                              .map(
                                (type) => DropdownMenuItem<String>(
                                  value: type["value"] as String,
                                  child: Row(
                                    children: [
                                      Icon(type["icon"],
                                          color: type["color"], size: 18),
                                      const SizedBox(width: 8),
                                      Text(type["label"]),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => selectedType = val ?? ""),
                        ),
                        const SizedBox(height: 16),

                        // Título
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: "Título de la Notificación",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Mensaje
                        TextField(
                          controller: _messageController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Mensaje",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Check todos
                        CheckboxListTile(
                          title: const Text("Enviar a todos los clientes"),
                          value: sendToAll,
                          onChanged: (val) =>
                              setState(() => sendToAll = val ?? false),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),

                        // Lista de clientes
                        if (!sendToAll)
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Scrollbar(
                              controller: _clientListController,
                              thumbVisibility: true,
                              child: ListView(
                                controller: _clientListController,
                                children: clients.map((client) {
                                  final selected =
                                      selectedClients.contains(client);
                                  return CheckboxListTile(
                                    title: Text(client),
                                    value: selected,
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedClients.add(client);
                                        } else {
                                          selectedClients.remove(client);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancelar"),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: (!sendToAll && selectedClients.isEmpty)
                                  ? null
                                  : _handleSendNotification,
                              icon: const Icon(Icons.send),
                              label: const Text("Enviar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        color: const Color.fromARGB(255, 250, 250, 250),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado principal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "Gestión de Notificaciones",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: _openNotificationDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Nueva Notificación"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Crea y gestiona las notificaciones enviadas a tus clientes",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Acciones rápidas
              const Text("Acciones Rápidas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 3.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: notificationTypes.map((type) {
                  return InkWell(
                    onTap: () {
                      setState(() => selectedType = type["value"]);
                      _openNotificationDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: type["color"],
                            child: Icon(type["icon"],
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(type["label"],
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Notificaciones enviadas
              const Text("Notificaciones Enviadas",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Column(
                children: sentNotifications.map((notification) {
                  final typeData = notificationTypes.firstWhere(
                      (t) => t["value"] == notification["type"],
                      orElse: () => {});
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: typeData["color"] ?? Colors.grey,
                          child: Icon(typeData["icon"] ?? Icons.notifications,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification["title"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(notification["message"],
                                  style: const TextStyle(fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.people,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                      "${notification["recipients"]} destinatarios"),
                                  const SizedBox(width: 6),
                                  const Text("•"),
                                  const SizedBox(width: 6),
                                  Text(notification["date"]),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Chip(
                          label: Text(notification["status"]),
                          backgroundColor: Colors.green[400],
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
