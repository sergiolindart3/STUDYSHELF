import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String projectName;
  final String description;
  final String repoLink;
  String? pdfFile;
  List<String>? evidenceImages;
  final String subject;
  String? imgProjectUrl; // Nueva propiedad para la imagen del proyecto
  final String userId;
  bool isActive;

  // Constructor
  ProjectModel({
    required this.id,
    required this.projectName,
    required this.description,
    required this.repoLink,
    this.pdfFile,
    this.evidenceImages,
    required this.subject,
    this.imgProjectUrl, // Inicializar en el constructor
    required this.userId,
    required this.isActive,
  });

  // Método para convertir el ProjectModel a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'description': description,
      'repoLink': repoLink,
      'pdfFile': pdfFile,
      'evidenceImages': evidenceImages,
      'subject': subject,
      'imgProjectUrl': imgProjectUrl, // Incluir en el Map
      'userId': userId,
      'isActive': isActive,
    };
  }

  // Crear una instancia de ProjectModel desde Firestore (deserialización)
  factory ProjectModel.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      projectName: data['projectName'] ?? '',
      description: data['description'] ?? '',
      repoLink: data['repoLink'] ?? '',
      pdfFile: data['pdfFile'],
      evidenceImages: List<String>.from(data['evidenceImages'] ?? []),
      subject: data['subject'] ?? '',
      imgProjectUrl: data['imgProjectUrl'], // Deserializar la URL de la imagen
      userId: data['userId'] ?? '',
      isActive: data['isActive'] ?? '',
    );
  }
}
