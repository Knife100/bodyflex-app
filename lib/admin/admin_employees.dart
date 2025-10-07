import 'package:flutter/material.dart';
import 'package:flutter_application_gym/admin/EmployeeCard.dart';
import 'package:flutter_application_gym/admin/EmployeeForm.dart';
import 'package:flutter_application_gym/admin/EmployeeSearchBar.dart';
import 'package:flutter_application_gym/models/employee_model.dart';
import 'package:flutter_application_gym/services/employee_service.dart';

class AdminEmployeesPage extends StatefulWidget {
  const AdminEmployeesPage({super.key});

  @override
  State<AdminEmployeesPage> createState() => _AdminEmployeesPageState();
}

class _AdminEmployeesPageState extends State<AdminEmployeesPage> {
  List<Employee> _employees = [];
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    final employees = await EmployeesApi.getEmployees();
    setState(() {
      _employees = employees;
    });
  }

  void _openEmployeeForm({Employee? employee}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.all(16),
        content: SizedBox(
          width: 600,
          child: EmployeeForm(
  initialData: employee,
  onSubmit: (newEmployee) {
    Navigator.of(context).pop();
    _loadEmployees();
  },
),
        ),
      ),
    );
  }

  void _confirmDelete(Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que deseas eliminar a ${employee.primerNombre} ${employee.primerApellido}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success =
          await EmployeesApi.deleteEmployee(employee.idEmpleado ?? 0);
      if (success) {
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado eliminado')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar empleado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = _employees.where((e) {
      final searchLower = _searchTerm.toLowerCase();
      return e.primerNombre.toLowerCase().contains(searchLower) ||
          e.primerApellido.toLowerCase().contains(searchLower) ||
          e.correo.toLowerCase().contains(searchLower) ||
          e.especialidad.toLowerCase().contains(searchLower);
    }).toList();

    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gestión de Empleados',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            EmployeeSearchBar(
              searchTerm: _searchTerm,
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Agregar Empleado'),
                onPressed: () => _openEmployeeForm(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(217, 119, 6, 1),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isWide
                  ? GridView.builder(
                      itemCount: filteredEmployees.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 3.5,
                      ),
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return EmployeeCard(
                          employee: employee,
                          onEdit: () => _openEmployeeForm(employee: employee),
                          onDelete: () => _confirmDelete(employee),
                        );
                      },
                    )
                  : ListView.separated(
                      itemCount: filteredEmployees.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return EmployeeCard(
                          employee: employee,
                          onEdit: () => _openEmployeeForm(employee: employee),
                          onDelete: () => _confirmDelete(employee),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
