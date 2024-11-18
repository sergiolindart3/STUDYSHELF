import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/controllers/project_controller.dart';
import 'package:studyshelf/models/project_model.dart';
import 'details_project.dart';

class NotifyPage extends StatelessWidget {
  final ProjectController _projectController = Get.put(ProjectController());

  NotifyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Revisar Proyectos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (_projectController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return StreamBuilder<List<ProjectModel>>(
            stream: _projectController.getPendingProjects(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar proyectos.'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No hay proyectos pendientes.'));
              } else {
                final projects = snapshot.data!;
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          // Navegar a la página de detalles del proyecto
                          Get.to(() => DetailsProject(project: project));
                        },
                        leading: project.imgProjectUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  project.imgProjectUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              )
                            : const Icon(Icons.image, size: 50),
                        title: Text(
                          project.projectName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              tooltip: 'Aceptar proyecto',
                              onPressed: () => _acceptProject(project),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                              tooltip: 'Rechazar proyecto',
                              onPressed: () => _deleteProject(project),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      }),
    );
  }

  void _acceptProject(ProjectModel project) async {
    await _projectController.updateProjectStatus(project.id, true);
  }

  void _deleteProject(ProjectModel project) async {
    try {
      await _projectController.deleteProject(project.id, project);
      Get.snackbar(
        'Proyecto Eliminado',
        'El proyecto fue eliminado correctamente.',
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo eliminar el proyecto.',
      );
    }
  }
}
