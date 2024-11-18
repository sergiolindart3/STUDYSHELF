import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/controllers/project_controller.dart';
import 'package:studyshelf/models/project_model.dart';
import 'details_project.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProjectController _projectController = Get.put(ProjectController());
  List<ProjectModel> _filteredProjects = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  // Cargar todos los proyectos
  void _loadProjects() {
    _projectController.getProjectsActive().listen((projects) {
      setState(() {
        _filteredProjects = projects;
      });
    });
  }

  // Método para filtrar proyectos en tiempo real
  void _filterProjects(String query) {
    setState(() {
      _searchText = query.toLowerCase();
      _filteredProjects = _projectController.projectsListByUser
          .where((project) =>
              project.projectName.toLowerCase().contains(_searchText) ||
              project.description.toLowerCase().contains(_searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Buscar Proyectos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterProjects,
              decoration: InputDecoration(
                hintText: 'Buscar proyectos...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // Lista de proyectos filtrados
          Expanded(
            child: _filteredProjects.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: ListTile(
                          onTap: () {
                            // Navegar a los detalles del proyecto
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
                          subtitle: Text(
                            project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(
                      _searchText.isEmpty
                          ? 'Escribe para buscar proyectos.'
                          : 'No se encontraron proyectos.',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
