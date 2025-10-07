class Client {
  final int? idUsuario; // lo asigna la BD
  final int? idCliente; // lo asigna la BD
  final String primerNombre;
  final String? segundoNombre;
  final String primerApellido;
  final String? segundoApellido;
  final String telefono;
  final String correo;
  final String contrasena;
  final String rol;
  final String administrador;       // "si"/"no" o "1"/"0"
  final String idPlan;              // id del plan como string
  final String? soportePago;
  final String fechaInicio;
  final String? idEntrenadorCreador;

  // Campos informativos que pueden venir expandidos del API
  final String? plan;
  final String? trainer;
  final String? status;

  Client({
    this.idUsuario,
    this.idCliente,
    required this.primerNombre,
    this.segundoNombre,
    required this.primerApellido,
    this.segundoApellido,
    required this.telefono,
    required this.correo,
    required this.contrasena,
    required this.rol,
    required this.administrador,
    required this.idPlan,
    this.soportePago,
    required this.fechaInicio,
    this.idEntrenadorCreador,
    this.plan,
    this.trainer,
    this.status,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idUsuario: json['id_usuario'],
      idCliente: json['id_cliente'],
      primerNombre: json['primer_nombre'] ?? '',
      segundoNombre: json['segundo_nombre'],
      primerApellido: json['primer_apellido'] ?? '',
      segundoApellido: json['segundo_apellido'],
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      contrasena: json['contrasena'] ?? '',
      rol: json['rol'] ?? '',
      administrador: json['administrador']?.toString() ?? '0',
      idPlan: json['id_plan']?.toString() ?? '0',
      soportePago: json['soporte_pago'],
      fechaInicio: json['fecha_inicio'] ?? '',
      idEntrenadorCreador: json['id_entrenador_creador']?.toString(),
      plan: json['plan'],
      trainer: json['trainer'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'primer_nombre': primerNombre,
      'segundo_nombre': segundoNombre,
      'primer_apellido': primerApellido,
      'segundo_apellido': segundoApellido,
      'telefono': telefono,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol,
      'administrador': administrador,
      'id_plan': idPlan,
      'soporte_pago': soportePago,
      'fecha_inicio': fechaInicio,
      'id_entrenador_creador': idEntrenadorCreador,
    };

    // Solo incluir en updates, no en creaciones
    if (idUsuario != null) data['id_usuario'] = idUsuario;
    if (idCliente != null) data['id_cliente'] = idCliente;

    return data;
  }
}
