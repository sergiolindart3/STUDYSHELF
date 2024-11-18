import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  // Obtener datos de todos los proyectos
  Stream<List<ProjectModel>> getProjectData() {
    return _firestore.collection('projects').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc)).toList();
    });
  }

  // Obtener proyectos por userId
  Stream<List<ProjectModel>> getUserProjects(String userId) {
    return _firestore
        .collection('projects')
        .where('userId', isEqualTo: userId) // Filtrar por userId
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc)).toList();
    });
  }

  // Obtener proyectos aceptados
  Stream<List<ProjectModel>> getActiveProjects() {
    return _firestore
        .collection('projects')
        .where('isActive', isEqualTo: true) // Filtrar por isActive
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc)).toList();
    });
  }

  // Actualizar el estado del proyecto en Firestore
  Future<void> updateProjectStatus(String projectId, bool isActive) async {
    try {
      await _firestore.collection('projects').doc(projectId).update({
        'isActive': isActive, // Actualizar el campo isActive
      });
    } catch (e) {
      print("Error al actualizar el estado del proyecto: $e");
    }
  }

  // Obtener proyectos pendientes (isActive == false)
  Stream<List<ProjectModel>> getPendingProjects() {
    return _firestore
        .collection('projects')
        .where('isActive', isEqualTo: false) // Filtrar por pendientes
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ProjectModel.fromMap(doc)).toList();
    });
  }

  // Eliminar un proyecto y sus archivos
  Future<void> deleteProject(String projectId, List<String>? filePaths) async {
    try {
      // Eliminar el documento de Firestore
      await _firestore.collection('projects').doc(projectId).delete();

      // Eliminar los archivos en Firebase Storage
      if (filePaths != null && filePaths.isNotEmpty) {
        for (var path in filePaths) {
          try {
            await _storage.refFromURL(path).delete();
          } catch (e) {
            print("Error al eliminar archivo $path: $e");
          }
        }
      }
    } catch (e) {
      print("Error al eliminar proyecto: $e");
      rethrow;
    }
  }
}
