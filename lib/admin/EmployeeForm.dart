import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/employee_model.dart';

class EmployeeForm extends StatefulWidget {
  final Employee? initialData;
  final void Function(Employee employee) onSubmit;

  const EmployeeForm({
    super.key,
    this.initialData,
    required this.onSubmit,
  });

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _primerNombreController;
  late TextEditingController _segundoNombreController;
  late TextEditingController _primerApellidoController;
  late TextEditingController _segundoApellidoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoController;
  late TextEditingController _rolController;
  late TextEditingController _especialidadController;

  bool _esAdmin = false;
  DateTime? _fechaContratacion;

  @override
  void initState() {
    super.initState();
    final e = widget.initialData;

    _primerNombreController = TextEditingController(text: e?.primerNombre ?? '');
    _segundoNombreController = TextEditingController(text: e?.segundoNombre ?? '');
    _primerApellidoController = TextEditingController(text: e?.primerApellido ?? '');
    _segundoApellidoController = TextEditingController(text: e?.segundoApellido ?? '');
    _telefonoController = TextEditingController(text: e?.telefono ?? '');
    _correoController = TextEditingController(text: e?.correo ?? '');
    _rolController = TextEditingController(text: e?.rol ?? '');
    _especialidadController = TextEditingController(text: e?.especialidad ?? '');
    _esAdmin = e?.administrador == "1";
    _fechaContratacion = e?.contratadoDesde != null
        ? DateTime.tryParse(e!.contratadoDesde)
        : null;
  }

  @override
  void dispose() {
    _primerNombreController.dispose();
    _segundoNombreController.dispose();
    _primerApellidoController.dispose();
    _segundoApellidoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _rolController.dispose();
    _especialidadController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final nuevoEmpleado = Employee(
        idEmpleado: widget.initialData?.idEmpleado,
        primerNombre: _primerNombreController.text.trim(),
        segundoNombre: _segundoNombreController.text.trim(),
        primerApellido: _primerApellidoController.text.trim(),
        segundoApellido: _segundoApellidoController.text.trim(),
        telefono: _telefonoController.text.trim(),
        correo: _correoController.text.trim(),
        rol: _rolController.text.trim(),
        administrador: _esAdmin ? "1" : "0",
        especialidad: _especialidadController.text.trim(),
        contratadoDesde: _fechaContratacion != null
            ? _fechaContratacion!.toIso8601String().split('T').first
            : "",
      );

      widget.onSubmit(nuevoEmpleado);
    }
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaContratacion ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _fechaContratacion = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _primerNombreController,
                  decoration: const InputDecoration(labelText: 'Primer Nombre'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _segundoNombreController,
                  decoration: const InputDecoration(labelText: 'Segundo Nombre'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _primerApellidoController,
                  decoration: const InputDecoration(labelText: 'Primer Apellido'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Campo requerido' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _segundoApellidoController,
                  decoration: const InputDecoration(labelText: 'Segundo Apellido'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _telefonoController,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _correoController,
            decoration: const InputDecoration(labelText: 'Correo'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Campo requerido';
              final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) return 'Correo inválido';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _rolController,
            decoration: const InputDecoration(labelText: 'Rol'),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text("¿Administrador?"),
            value: _esAdmin,
            onChanged: (value) {
              setState(() {
                _esAdmin = value;
              });
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _especialidadController,
            decoration: const InputDecoration(labelText: 'Especialidad'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Contratado desde"),
            subtitle: Text(
              _fechaContratacion != null
                  ? DateFormat('dd/MM/yyyy').format(_fechaContratacion!)
                  : "No seleccionada",
              style: const TextStyle(color: Colors.grey),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDate,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
            label: const Text("Guardar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(217, 119, 6, 1),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }
}
