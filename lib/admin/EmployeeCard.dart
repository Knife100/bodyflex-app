import 'package:flutter/material.dart';
import 'package:flutter_application_gym/models/employee_model.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person, size: 40, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${employee.primerNombre} ${employee.primerApellido}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    employee.correo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Tel: ${employee.telefono}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Rol: ${employee.rol}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Especialidad: ${employee.especialidad}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Contratado desde: ${employee.contratadoDesde}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
