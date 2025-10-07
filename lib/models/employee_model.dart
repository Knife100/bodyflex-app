class Employee {
  final int? idEmpleado; // asignado por la BD
  final String primerNombre;
  final String? segundoNombre;
  final String primerApellido;
  final String? segundoApellido;
  final String telefono;
  final String correo;
  final String rol;
  final String administrador; // "si"/"no" o "1"/"0"
  final String especialidad;
  final String contratadoDesde;

  Employee({
    this.idEmpleado,
    required this.primerNombre,
    this.segundoNombre,
    required this.primerApellido,
    this.segundoApellido,
    required this.telefono,
    required this.correo,
    required this.rol,
    required this.administrador,
    required this.especialidad,
    required this.contratadoDesde,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      idEmpleado: json['id_empleado'],
      primerNombre: json['primer_nombre'] ?? '',
      segundoNombre: json['segundo_nombre'],
      primerApellido: json['primer_apellido'] ?? '',
      segundoApellido: json['segundo_apellido'],
      telefono: json['telefono'] ?? '',
      correo: json['correo'] ?? '',
      rol: json['rol'] ?? '',
      administrador: json['administrador']?.toString() ?? '0',
      especialidad: json['especialidad'] ?? '',
      contratadoDesde: json['contratado_desde'] ?? '',
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
      'rol': rol,
      'administrador': administrador,
      'especialidad': especialidad,
      'contratado_desde': contratadoDesde,
    };

    if (idEmpleado != null) data['id_empleado'] = idEmpleado;

    return data;
  }
}
