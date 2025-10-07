import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_gym/models/client_model.dart';
import 'package:flutter_application_gym/models/plan_model.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final List<PlanFromAPI> plans;
  final void Function(Client client) onEdit;
  final void Function(int id) onDelete;

  const ClientCard({
    Key? key,
    required this.client,
    required this.plans,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Buscar el plan del cliente
    final plan = plans.firstWhere(
      (p) => p.idPlan == int.tryParse(client.idPlan),
      orElse: () => PlanFromAPI(
        idPlan: 0,
        descripcion: "Sin plan",
        precio: 0,
        duracionDias: 0,
        beneficios: "",
        estado: "inactivo",
      ),
    );

    final planDesc = plan.descripcion;

    // Calcular fechas
    DateTime? fechaInicio = DateTime.tryParse(client.fechaInicio);

    DateTime? vencimiento = (fechaInicio != null && plan.duracionDias > 0)
        ? fechaInicio.add(Duration(days: plan.duracionDias))
        : null;

    bool activo =
        vencimiento != null ? DateTime.now().isBefore(vencimiento) : false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: isLargeScreen
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Información del cliente
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber.shade100,
                            child: Icon(Icons.person, color: Colors.amber.shade700),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${client.primerNombre} ${client.segundoNombre ?? ''} "
                                "${client.primerApellido} ${client.segundoApellido ?? ''}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.mail, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  SizedBox(
                                    width: 200, // límite fijo para pantallas grandes
                                    child: Text(
                                      client.correo,
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    client.telefono,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Ingreso: ${fechaInicio != null ? DateFormat('dd/MM/yyyy').format(fechaInicio) : "No asignada"}",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Estado del cliente + botones
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Badge del plan
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              planDesc,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Estado + botones
                          Wrap(
                            spacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: activo ? Colors.green : Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  activo ? "Activo" : "Vencido",
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () => onEdit(client),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: () => onDelete(client.idUsuario!),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.amber.shade100,
                            child: Icon(Icons.person, color: Colors.amber.shade700),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${client.primerNombre} ${client.segundoNombre ?? ''} "
                                  "${client.primerApellido} ${client.segundoApellido ?? ''}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.mail, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        client.correo,
                                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        client.telefono,
                                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Ingreso: ${fechaInicio != null ? DateFormat('dd/MM/yyyy').format(fechaInicio) : "No asignada"}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              planDesc,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: activo ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              activo ? "Activo" : "Vencido",
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () => onEdit(client),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                            onPressed: () => onDelete(client.idUsuario!),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
