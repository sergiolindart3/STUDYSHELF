import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:studyshelf/models/project_model.dart';

class ProjectService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Método para subir cualquier archivo a Firebase (PDF o imagen)
  Future<String?> uploadFile(File file, String path) async {
    try {
      Reference storageReference = _storage.ref(path);
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir archivo: $e");
      return null;
    }
  }

  // Subir archivo desde web (PDF o imagen)
  Future<String?> uploadFileWeb(Uint8List fileBytes, String path) async {
    try {
      Reference storageReference = _storage.ref(path);
      UploadTask uploadTask = storageReference.putData(fileBytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir archivo: $e");
      return null;
    }
  }

  // Guardar proyecto en Firestore
  Future<void> saveProject(ProjectModel project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .set(project.toMap());
    } catch (e) {
      print("Error al guardar proyecto: $e");
    }
  }

  // Obtener datos de los proyectos
  Stream<List<ProjectModel>> getProjectData() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc)).toList();
    });
  }
}
