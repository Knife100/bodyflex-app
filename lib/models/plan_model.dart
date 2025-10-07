class PlanFromAPI {
  final int idPlan;
  final String descripcion;
  final double precio;
  final int duracionDias;
  final String beneficios;
  final String estado;

  PlanFromAPI({
    required this.idPlan,
    required this.descripcion,
    required this.precio,
    required this.duracionDias,
    required this.beneficios,
    required this.estado,
  });

factory PlanFromAPI.fromJson(Map<String, dynamic> json) {
  return PlanFromAPI(
    idPlan: json['id_plan'] is int
        ? json['id_plan']
        : int.tryParse(json['id_plan'].toString()) ?? 0,
    descripcion: json['descripcion'] ?? '',
    precio: json['precio'] is num
        ? (json['precio'] as num).toDouble()
        : double.tryParse(json['precio'].toString()) ?? 0.0,
    duracionDias: json['duracion_dias'] is int
        ? json['duracion_dias']
        : int.tryParse(json['duracion_dias'].toString()) ?? 0,
    beneficios: json['beneficios'] ?? '',
    estado: json['estado'] ?? 'inactivo',
  );
}


  Map<String, dynamic> toJson() => {
        'id_plan': idPlan,
        'descripcion': descripcion,
        'precio': precio,
        'duracion_dias': duracionDias,
        'beneficios': beneficios,
        'estado': estado,
      };
}

class Plan {
  final int id;
  final String name;
  final double price;
  final String duration;
  final String description;
  final List<String> features;
  final String status;
  final int? subscribers;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
    required this.description,
    required this.features,
    required this.status,
    this.subscribers,
  });
}

class PlanPayload {
  final String descripcion;
  final double precio;
  final int duracionDias;
  final String beneficios;
  final String estado;

  PlanPayload({
    required this.descripcion,
    required this.precio,
    required this.duracionDias,
    required this.beneficios,
    required this.estado,
  });

  Map<String, dynamic> toJson() => {
        'descripcion': descripcion,
        'precio': precio,
        'duracion_dias': duracionDias,
        'beneficios': beneficios,
        'estado': estado,
      };
}

/// 🔁 Extensión que convierte PlanFromAPI → Plan
extension PlanMapper on PlanFromAPI {
  Plan toUI() {
    return Plan(
      id: idPlan,
      name: descripcion,
      price: precio,
      duration: "$duracionDias días",
      description: beneficios,
      features: beneficios.split(',').map((s) => s.trim()).toList(),
      status: estado == "activo" ? "Activo" : "Inactivo",
    );
  }
}
