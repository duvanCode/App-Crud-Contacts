class User {
  final String id;
  final String name;
  final String email;
  final String? number;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.number,
  });

  // Convertir User a Map para Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'number': number,
    };
  }

  // Crear User desde Map de Firebase
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      number: json['number'] as String?,
    );
  }
}