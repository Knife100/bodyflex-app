import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../services/plan_service.dart'; // Debes tener tus métodos getPlans, createPlan, updatePlan, deletePlan

class AdminPlansPage extends StatefulWidget {
  const AdminPlansPage({super.key});

  @override
  State<AdminPlansPage> createState() => _AdminPlansPageState();
}

class _AdminPlansPageState extends State<AdminPlansPage> {
  List<Plan> plans = [];
  List<Plan> filteredPlans = [];
  bool isLoading = false;
  String searchTerm = "";
  Plan? editingPlan;
  final _formKey = GlobalKey<FormState>();

  // Controladores del formulario
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController beneficiosController = TextEditingController();
  String selectedStatus = "Activo";

  @override
  void initState() {
    super.initState();
    loadPlans();
  }

  Future<void> loadPlans() async {
    setState(() => isLoading = true);
    try {
      final data = await PlanApi.getPlans(); // ← devuelve List<PlanFromAPI>
      final mapped = data.map((p) => p.toUI()).toList(); // extensión PlanMapper
      setState(() {
        plans = mapped;
        filteredPlans = mapped;
      });
    } catch (e) {
      debugPrint("Error cargando planes: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void openCreateDialog() {
    setState(() {
      editingPlan = null;
      nameController.clear();
      priceController.clear();
      durationController.clear();
      beneficiosController.clear();
      selectedStatus = "Activo";
    });
    showPlanDialog();
  }

  void openEditDialog(Plan plan) {
    setState(() {
      editingPlan = plan;
      nameController.text = plan.name;
      priceController.text = plan.price.toString();
      durationController.text = plan.duration.replaceAll(" días", "");
      beneficiosController.text = plan.description;
      selectedStatus = plan.status;
    });
    showPlanDialog();
  }

  void showPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editingPlan == null ? 'Crear Nuevo Plan' : 'Editar Plan'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Precio (COP)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: durationController,
                  decoration: const InputDecoration(labelText: 'Duración (días)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                TextFormField(
                  controller: beneficiosController,
                  decoration: const InputDecoration(labelText: 'Beneficios'),
                  maxLines: 4,
                  validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  decoration: const InputDecoration(labelText: 'Estado'),
                  items: const [
                    DropdownMenuItem(value: "Activo", child: Text("Activo")),
                    DropdownMenuItem(value: "Inactivo", child: Text("Inactivo")),
                  ],
                  onChanged: (v) => setState(() => selectedStatus = v!),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[700]),
            onPressed: handleSubmit,
            child: Text(editingPlan == null ? 'Crear Plan' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final newPlan = PlanPayload(
      descripcion: nameController.text,
      precio: double.tryParse(priceController.text) ?? 0,
      duracionDias: int.tryParse(durationController.text) ?? 0,
      beneficios: beneficiosController.text,
      estado: selectedStatus == "Activo" ? "activo" : "inactivo",
    );

    try {
      if (editingPlan != null) {
        await PlanApi.updatePlan(editingPlan!.id, newPlan);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan actualizado exitosamente')),
        );
      } else {
        await PlanApi.createPlan(newPlan);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nuevo plan creado exitosamente')),
        );
      }
      Navigator.pop(context);
      await loadPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> handleToggleStatus(Plan plan) async {
    final updated = PlanPayload(
      descripcion: plan.name,
      precio: plan.price,
      duracionDias: int.tryParse(plan.duration.replaceAll(' días', '')) ?? 0,
      beneficios: plan.description,
      estado: plan.status == "Activo" ? "inactivo" : "activo",
    );

    try {
      await PlanApi.updatePlan(plan.id, updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Estado del plan cambiado')),
      );
      await loadPlans();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cambiar estado: $e')),
      );
    }
  }

  Future<void> handleDelete(Plan plan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¿Eliminar Plan?"),
        content: Text(
            'Esta acción eliminará el plan "${plan.name}" de forma permanente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await PlanApi.deletePlan(plan.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan eliminado exitosamente')),
        );
        await loadPlans();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error eliminando plan: $e')),
        );
      }
    }
  }

  void searchPlans(String term) {
    setState(() {
      searchTerm = term;
      filteredPlans = plans
          .where((p) =>
              p.name.toLowerCase().contains(term.toLowerCase()) ||
              p.description.toLowerCase().contains(term.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Planes y Membresías'),
        backgroundColor: Colors.amber[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: openCreateDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Buscar por nombre o beneficios...',
                    ),
                    onChanged: searchPlans,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredPlans.isEmpty
                        ? const Center(child: Text('No hay planes disponibles'))
                        : ListView.builder(
                            itemCount: filteredPlans.length,
                            itemBuilder: (context, index) {
                              final plan = filteredPlans[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(plan.name,
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold)),
                                          Chip(
                                            label: Text(plan.status),
                                            backgroundColor: plan.status ==
                                                    "Activo"
                                                ? Colors.green[300]
                                                : Colors.red[300],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        plan.description,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Duración: ${plan.duration}  |  Precio: \$${plan.price.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () =>
                                                handleToggleStatus(plan),
                                            icon: const Icon(Icons
                                                .toggle_on_outlined),
                                            label: Text(plan.status == "Activo"
                                                ? "Desactivar"
                                                : "Activar"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors
                                                  .amberAccent.shade700,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () =>
                                                openEditDialog(plan),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                handleDelete(plan),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
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
