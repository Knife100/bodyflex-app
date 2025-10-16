import 'package:flutter/material.dart';
import 'package:flutter_application_gym/models/client_model.dart';
import 'package:flutter_application_gym/models/plan_model.dart';

class ClientForm extends StatefulWidget {
  final Client? client;
  final List<PlanFromAPI> plans;
  final void Function(Client data) onSubmit;
  final VoidCallback onClose;

  // ✅ NUEVO PARÁMETRO
  final String userType; // "admin" o "trainer"

  const ClientForm({
    Key? key,
    this.client,
    required this.plans,
    required this.onSubmit,
    required this.onClose,
    required this.userType, // 👈 debe agregarse aquí
  }) : super(key: key);

  @override
  _ClientFormState createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  late TextEditingController primerNombreCtrl;
  late TextEditingController segundoNombreCtrl;
  late TextEditingController primerApellidoCtrl;
  late TextEditingController segundoApellidoCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController correoCtrl;
  late TextEditingController soportePagoCtrl;
  late TextEditingController fechaInicioCtrl;
  late TextEditingController entrenadorCtrl;

  // Dropdowns
  String rol = "cliente";
  String administrador = "no";
  String? planSeleccionado;

  @override
  void initState() {
    super.initState();

    final c = widget.client;
    primerNombreCtrl = TextEditingController(text: c?.primerNombre ?? "");
    segundoNombreCtrl = TextEditingController(text: c?.segundoNombre ?? "");
    primerApellidoCtrl = TextEditingController(text: c?.primerApellido ?? "");
    segundoApellidoCtrl = TextEditingController(text: c?.segundoApellido ?? "");
    telefonoCtrl = TextEditingController(text: c?.telefono ?? "");
    correoCtrl = TextEditingController(text: c?.correo ?? "");
    soportePagoCtrl = TextEditingController(text: c?.soportePago ?? "");
    fechaInicioCtrl = TextEditingController(text: c?.fechaInicio ?? "");
    entrenadorCtrl = TextEditingController(text: c?.idEntrenadorCreador ?? "");

    rol = c?.rol ?? "cliente";
    administrador =
        (c?.administrador == "si" || c?.administrador == "1") ? "si" : "no";
    planSeleccionado = c?.idPlan.toString();
  }

  @override
  void dispose() {
    primerNombreCtrl.dispose();
    segundoNombreCtrl.dispose();
    primerApellidoCtrl.dispose();
    segundoApellidoCtrl.dispose();
    telefonoCtrl.dispose();
    correoCtrl.dispose();
    soportePagoCtrl.dispose();
    fechaInicioCtrl.dispose();
    entrenadorCtrl.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final client = Client(
        idUsuario: widget
            .client?.idUsuario, // ⚠️ usar null-safe (si es creación será null)
        idCliente: widget.client?.idCliente,
        primerNombre: primerNombreCtrl.text,
        segundoNombre:
            segundoNombreCtrl.text.isNotEmpty ? segundoNombreCtrl.text : null,
        primerApellido: primerApellidoCtrl.text,
        segundoApellido: segundoApellidoCtrl.text.isNotEmpty
            ? segundoApellidoCtrl.text
            : null,
        telefono: telefonoCtrl.text,
        correo: correoCtrl.text,
        contrasena: widget.client?.contrasena ?? "123456",
        rol: rol,
        administrador: administrador,
        idPlan: planSeleccionado ?? "",
        soportePago:
            soportePagoCtrl.text.isNotEmpty ? soportePagoCtrl.text : null,
        fechaInicio: fechaInicioCtrl.text,
        idEntrenadorCreador:
            entrenadorCtrl.text.isNotEmpty ? entrenadorCtrl.text : null,
      );

      // 📌 Imprimir en consola el objeto y el JSON
      print("======= CLIENTE FORMULARIO =======");
      print("Objeto Client: $client");
      print("JSON: ${client.toJson()}");
      print("=================================");

      widget.onSubmit(client);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.client != null
                    ? "Editar Cliente"
                    : "Registrar Nuevo Cliente",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(widget.client != null
                  ? "Modifica la información del cliente"
                  : "Ingresa los datos del nuevo cliente"),
              const SizedBox(height: 16),

              // Nombres
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: primerNombreCtrl,
                      decoration:
                          const InputDecoration(labelText: "Primer Nombre *"),
                      validator: (v) => v == null || v.isEmpty
                          ? "El primer nombre es obligatorio"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: segundoNombreCtrl,
                      decoration:
                          const InputDecoration(labelText: "Segundo Nombre"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Apellidos
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: primerApellidoCtrl,
                      decoration:
                          const InputDecoration(labelText: "Primer Apellido *"),
                      validator: (v) => v == null || v.isEmpty
                          ? "El primer apellido es obligatorio"
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: segundoApellidoCtrl,
                      decoration:
                          const InputDecoration(labelText: "Segundo Apellido"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Contacto
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: telefonoCtrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: "Teléfono *"),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "El teléfono es obligatorio";
                        if (!RegExp(r"^3\d{9}$").hasMatch(v)) {
                          return "Debe iniciar con 3 y tener 10 dígitos";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: correoCtrl,
                      readOnly: widget.client != null,
                      decoration: InputDecoration(
                        labelText: "Correo *",
                        filled: widget.client != null,
                        fillColor:
                            widget.client != null ? Colors.grey.shade200 : null,
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty)
                          return "El correo es obligatorio";
                        if (!RegExp(r"^[^@]+@[^@]+\.[a-zA-Z]{2,}$")
                            .hasMatch(v)) {
                          return "Correo inválido";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rol y admin
              // Rol y admin
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: rol,
                      decoration: const InputDecoration(labelText: "Rol *"),
                      items: const [
                        DropdownMenuItem(
                            value: "cliente", child: Text("Cliente")),
                        DropdownMenuItem(
                            value: "entrenador", child: Text("Entrenador")),
                      ],
                      onChanged: (val) => setState(() => rol = val!),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // 👇 Solo mostrar este dropdown si es admin
                  if (widget.userType == "admin")
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: administrador,
                        decoration:
                            const InputDecoration(labelText: "Administrador *"),
                        items: const [
                          DropdownMenuItem(value: "si", child: Text("Sí")),
                          DropdownMenuItem(value: "no", child: Text("No")),
                        ],
                        onChanged: (val) =>
                            setState(() => administrador = val!),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Plan
              DropdownButtonFormField<String>(
                initialValue: planSeleccionado,
                decoration:
                    const InputDecoration(labelText: "Plan de Membresía *"),
                items: widget.plans
                    .map((p) => DropdownMenuItem(
                          value: p.idPlan.toString(),
                          child: Text(p.descripcion),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => planSeleccionado = val),
                validator: (v) => v == null ? "Selecciona un plan" : null,
              ),
              const SizedBox(height: 12),

              // Soporte de pago
              TextFormField(
                controller: soportePagoCtrl,
                decoration: const InputDecoration(labelText: "Soporte de Pago"),
              ),
              const SizedBox(height: 12),

              // Fecha inicio
              TextFormField(
                controller: fechaInicioCtrl,
                decoration:
                    const InputDecoration(labelText: "Fecha de Ingreso *"),
                keyboardType: TextInputType.datetime,
                validator: (v) => v == null || v.isEmpty
                    ? "La fecha de ingreso es obligatoria"
                    : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      fechaInicioCtrl.text =
                          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Entrenador
              TextFormField(
                controller: entrenadorCtrl,
                decoration: const InputDecoration(labelText: "Entrenador (ID)"),
              ),
              const SizedBox(height: 20),

              // Botones
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade600,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: Text(widget.client != null
                    ? "Actualizar Cliente"
                    : "Registrar Cliente"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
