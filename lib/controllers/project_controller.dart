import 'dart:io';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/project_model.dart';
import '../services/project_service.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectController extends GetxController {
  final ProjectService _projectService = ProjectService();
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<ProjectModel> projectsListByUser = <ProjectModel>[].obs;

  var isLoading = false.obs;
  var pdfFile = Rxn<File>();
  var pdfFileWeb = Rxn<Uint8List>();
  var evidenceFiles = <File>[].obs;
  var evidenceFilesWeb = <Uint8List>[].obs;
  File? selectedProjectImage; // Nueva variable para la imagen del proyecto

  // Obtener datos de todos los projects
  Stream<List<ProjectModel>> getProjectData() {
    return _projectService.getProjectData();
  }

  // Obtener proyectos de un usuario específico
  Stream<List<ProjectModel>> getProjectsByUser(String userId) {
    return _projectService.getUserProjects(userId);
  }

  //Obtener proyectos aceptados
  Stream<List<ProjectModel>> getProjectsActive() {
    return _projectService.getActiveProjects();
  }

// Obtener proyectos pendientes
  Stream<List<ProjectModel>> getPendingProjects() {
    return _projectService.getPendingProjects();
  }

  // Método para seleccionar imagen del proyecto
  Future<void> pickProjectImage() async {
    if (kIsWeb) {
      // Web: usar FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.first.bytes != null) {
        selectedProjectImage =
            File(result.files.first.name); // Solo para simulación
      }
    } else {
      // Móvil: usar ImagePicker
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedProjectImage = File(pickedFile.path);
      }
    }
  }

  // Método para seleccionar PDF
  Future<void> pickPDF() async {
    if (kIsWeb) {
      // Web: usar FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.first.bytes != null) {
        pdfFileWeb.value = result.files.first.bytes;
      }
    } else {
      // Móvil: usar FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.first.path != null) {
        pdfFile.value = File(result.files.first.path!);
      }
    }
  }

  // Método para seleccionar evidencias (imágenes)
  Future<void> pickEvidence() async {
    if (kIsWeb) {
      // Web: usar FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        evidenceFilesWeb.value =
            result.files.map((file) => file.bytes!).toList();
      }
    } else {
      // Móvil: usar ImagePicker
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != null) {
        evidenceFiles.value =
            pickedFiles.map((file) => File(file.path)).toList();
      }
    }
  }

  // Guardar un nuevo proyecto
  Future<void> saveNewProject(
    String projectName,
    String description,
    String repoLink,
    String subject,
    String userId,
    bool isActive,
  ) async {
    try {
      isLoading.value = true;
      String id = const Uuid().v4();

      // Subir la imagen del proyecto
      String? imgProjectUrl;
      if (selectedProjectImage != null) {
        imgProjectUrl = await _projectService.uploadFile(
          selectedProjectImage!,
          'projects/$id/imgProject', // Ruta en Firebase
        );
      }

      // Subir el PDF
      String? pdfUrl;
      if (pdfFile.value != null) {
        // Para dispositivos móviles, usa uploadFile (para archivos locales)
        pdfUrl = await _projectService.uploadFile(
          pdfFile.value!, // Para móvil
          'projects/$id/pdf',
        );
      } else if (pdfFileWeb.value != null) {
        // Para Web, usa uploadFileWeb (para archivos web)
        pdfUrl = await _projectService.uploadFileWeb(
          pdfFileWeb.value!, // Para Web
          'projects/$id/pdf',
        );
      }

      // Subir las evidencias
      List<String> evidenceUrls = [];
      for (var evidence in evidenceFiles) {
        String? evidenceUrl = await _projectService.uploadFile(
          evidence,
          'projects/$id/evidences/${evidence.path.split('/').last}',
        );
        if (evidenceUrl != null) {
          evidenceUrls.add(evidenceUrl);
        }
      }

      // Crear y guardar el proyecto
      ProjectModel newProject = ProjectModel(
          id: id,
          projectName: projectName,
          description: description,
          repoLink: repoLink,
          pdfFile: pdfUrl,
          evidenceImages: evidenceUrls,
          subject: subject,
          imgProjectUrl:
              imgProjectUrl, // Guardar la URL de la imagen del proyecto
          userId: userId,
          isActive: isActive);

      await _projectService.saveProject(newProject);
      Get.snackbar('Éxito', 'Proyecto guardado exitosamente');
      clearFields();
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al guardar el proyecto');
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    pdfFile.value = null;
    pdfFileWeb.value = null;
    evidenceFiles.clear();
    evidenceFilesWeb.clear();
    selectedProjectImage = null;
  }

  // Actualizar el estado del proyecto
  Future<void> updateProjectStatus(String projectId, bool isActive) async {
    try {
      isLoading.value = true;
      await _projectService.updateProjectStatus(projectId, isActive);
      Get.snackbar(
          'Éxito', 'El estado del proyecto se actualizó correctamente');
    } catch (e) {
      Get.snackbar('Error', 'No se pudo actualizar el estado del proyecto');
    } finally {
      isLoading.value = false;
    }
  }

  // Función para eliminar un proyecto
  Future<void> deleteProject(String projectId, ProjectModel project) async {
    // Recolectar las rutas de los archivos asociados al proyecto
    List<String> filePaths = [];

    if (project.imgProjectUrl != null) filePaths.add(project.imgProjectUrl!);
    if (project.pdfFile != null) filePaths.add(project.pdfFile!);
    if (project.evidenceImages != null) {
      filePaths.addAll(project.evidenceImages!);
    }

    // Llamar al servicio para eliminar el proyecto y los archivos
    await _projectService.deleteProject(projectId, filePaths);
  }
}
