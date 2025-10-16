import 'package:flutter/material.dart';
import 'package:flutter_application_gym/models/client_model.dart';
import 'package:flutter_application_gym/models/plan_model.dart';
import 'package:flutter_application_gym/services/client_service.dart';
import 'package:flutter_application_gym/services/plan_service.dart';
import 'package:flutter_application_gym/clients-section/clientCard.dart';
import 'package:flutter_application_gym/clients-section/clientForm.dart';
import 'package:flutter_application_gym/clients-section/ClientSearchBar.dart';

class ClientsPage extends StatefulWidget {
  final String userType; // "admin" o "trainer"

  const ClientsPage(
      {super.key, this.userType = "admin"}); // admin por defecto

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  List<Client> clients = [];
  List<PlanFromAPI> plans = [];
  Client? editingClient;
  String searchTerm = "";
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() => loading = true);
    try {
      final fetchedClients = await ClientsApi.getClients();
      final fetchedPlans = await PlanApi.getPlans();

      setState(() {
        clients = fetchedClients;
        plans = fetchedPlans;
      });
    } catch (e) {
      debugPrint("Error al cargar clientes o planes: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void openForm([Client? client]) {
    setState(() {
      editingClient = client;
    });
    showDialog(
      context: context,
      builder: (_) => ClientForm(
        client: editingClient,
        plans: plans,
        onSubmit: handleSubmit,
        onClose: () {
          Navigator.pop(context);
          setState(() => editingClient = null);
        },
        userType: widget.userType, // 👈 ahora se pasa correctamente
      ),
    );
  }

  Future<void> handleSubmit(Client data) async {
    try {
      if (editingClient != null) {
        await ClientsApi.updateClient(editingClient!.idUsuario!, data);
      } else {
        await ClientsApi.createClient(data);
      }

      await fetchData();
      Navigator.pop(context);
      setState(() => editingClient = null);
    } catch (e, stack) {
      debugPrint("❌ Error al guardar cliente: $e");
      debugPrint("STACK TRACE: $stack");
    }
  }

  Future<void> handleDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar"),
        content: const Text("¿Eliminar este cliente?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Eliminar")),
        ],
      ),
    );
    if (confirm == true) {
      await ClientsApi.deleteClient(id);
      setState(() {
        clients.removeWhere((c) => c.idUsuario == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredClients = clients.where((client) {
      final fullName =
          "${client.primerNombre} ${client.segundoNombre ?? ""} ${client.primerApellido} ${client.segundoApellido ?? ""}"
              .toLowerCase();
      final term = searchTerm.toLowerCase();
      return fullName.contains(term) ||
          (client.correo.toLowerCase().contains(term));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión Completa de Clientes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => openForm(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 800;

            return isLargeScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📋 Lista de clientes (lado izquierdo en pantallas grandes)
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            ClientSearchBar(
                              searchTerm: searchTerm,
                              onChanged: (value) =>
                                  setState(() => searchTerm = value),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: loading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : filteredClients.isEmpty
                                      ? const Center(
                                          child: Text(
                                              "No se encontraron clientes."))
                                      : ListView.builder(
                                          itemCount: filteredClients.length,
                                          itemBuilder: (context, index) {
                                            final client =
                                                filteredClients[index];
                                            return ClientCard(
                                              client: client,
                                              plans: plans,
                                              onEdit: openForm,
                                              onDelete: handleDelete,
                                            );
                                          },
                                        ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 16),
                    ],
                  )
                : Column(
                    children: [
                      ClientSearchBar(
                        searchTerm: searchTerm,
                        onChanged: (value) =>
                            setState(() => searchTerm = value),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: loading
                            ? const Center(child: CircularProgressIndicator())
                            : filteredClients.isEmpty
                                ? const Center(
                                    child: Text("No se encontraron clientes."))
                                : ListView.builder(
                                    itemCount: filteredClients.length,
                                    itemBuilder: (context, index) {
                                      final client = filteredClients[index];
                                      return ClientCard(
                                        client: client,
                                        plans: plans,
                                        onEdit: openForm,
                                        onDelete: handleDelete,
                                      );
                                    },
                                  ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
