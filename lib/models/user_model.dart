class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String email;
  final String phone;
  String? imageUrl;

  // Constructor
  UserModel({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  // Método para convertir el UserModel a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
    };
  }

  // Crear una instancia de UserModel desde Firestore (deserialización)
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      imageUrl: data['imageUrl'],
    );
  }
}
