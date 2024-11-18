import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/controllers/project_controller.dart';
import '../models/project_model.dart';
import 'details_project.dart'; // Importa la página de detalles del proyecto
import 'package:studyshelf/pages/widgets/project_tile.dart'; // Importa el widget ProjectTile

class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  final ProjectController _projectController = Get.put(ProjectController());
  String? _selectedFilter; // Variable para almacenar el filtro seleccionado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos los Proyectos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0), // Añadir espacio
            child: IconButton(
              icon:
                  const Icon(Icons.filter_list, size: 28), // Aumentar el tamaño
              onPressed: () {
                _showFilterDialog(context);
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (_projectController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: StreamBuilder<List<ProjectModel>>(
                  stream: _projectController.getProjectsActive(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error al cargar proyectos.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No hay proyectos activos.'));
                    } else {
                      final projects = snapshot.data!;
                      final filteredProjects = _selectedFilter != null
                          ? projects
                              .where((p) =>
                                  p.subject ==
                                  _selectedFilter) // Filtrar por asignatura
                              .toList()
                          : projects;

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredProjects.length,
                              itemBuilder: (context, index) {
                                final project = filteredProjects[index];
                                return ProjectTile(
                                  project: project,
                                  onTap: () {
                                    // Navegar a la página de detalles del proyecto
                                    Get.to(
                                        () => DetailsProject(project: project));
                                  },
                                  showStatusIcon: false,
                                );
                              },
                            ),
                          ),
                          // Mostrar la etiqueta del filtro seleccionado
                          if (_selectedFilter != null)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Filtro: $_selectedFilter',
                                          style: const TextStyle(
                                            color: Color(0xFF5292CA),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _selectedFilter =
                                                  null; // Deseleccionar filtro
                                            });
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Color(0xFF5292CA),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    }
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Filtro'),
          content: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Asignatura',
              border: OutlineInputBorder(),
            ),
            value: _selectedFilter,
            items: const [
              DropdownMenuItem(
                value: 'PROGRAMACION',
                child: Text('PROGRAMACION'),
              ),
              DropdownMenuItem(
                value: 'SOFTWARE',
                child: Text('SOFTWARE'),
              ),
              DropdownMenuItem(
                value: 'MOVIL',
                child: Text('MOVIL'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFilter = value;
              });
              Navigator.pop(context); // Cerrar el diálogo
            },
          ),
        );
      },
    );
  }
}
