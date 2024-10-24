import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_controller.dart';
import 'package:studyshelf/pages/widgets/custom_button.dart';
import 'package:studyshelf/pages/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/project_model.dart'; // Asegúrate de importar tu modelo de proyecto
import 'details_project.dart'; // Asegúrate de importar la página de detalles del proyecto
import 'package:studyshelf/pages/widgets/project_tile.dart'; // Importa el widget ProjectTile

class CrearProject extends StatefulWidget {
  @override
  _CrearProjectState createState() => _CrearProjectState();
}

class _CrearProjectState extends State<CrearProject> {
  final ProjectController _projectController = Get.put(ProjectController());
  File? _selectedProjectImage; // Imagen seleccionada para el proyecto
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _repoLinkController = TextEditingController();
  String? _selectedSubject;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _repoLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(StateSetter setModalState) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setModalState(() {
        _selectedProjectImage = File(pickedFile.path);
        _projectController.selectedProjectImage = _selectedProjectImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos los Proyectos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.grey[300],
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                ),
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                      return _buildProjectFormModal(context, setModalState);
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Obx(() {
            if (_projectController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Expanded(
                child: StreamBuilder<List<ProjectModel>>(
                  stream: _projectController.getProjectData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error al cargar proyectos.'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No hay proyectos disponibles.'));
                    } else {
                      final projects = snapshot.data!;
                      return ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          final project = projects[index];
                          return ProjectTile(
                            project: project,
                            onTap: () {
                              // Navegar a la página de detalles del proyecto
                              Get.to(() => DetailsProject(project: project));
                            },
                          );
                        },
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

  // Modal de agregar proyecto
  Widget _buildProjectFormModal(
      BuildContext context, StateSetter setModalState) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9, // 90% de la pantalla
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nuevo Proyecto',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Selector de imagen del proyecto
            GestureDetector(
              onTap: () => _pickImage(setModalState),
              child: SizedBox(
                height: 120,
                child: _selectedProjectImage != null
                    ? Image.file(
                        _selectedProjectImage!,
                        fit: BoxFit.contain,
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Colors.grey,
                      ),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: 'Nombre del Proyecto',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Descripción',
              controller: _descriptionController,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: 'Link de repositorio',
              controller: _repoLinkController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Text(
                        _projectController.pdfFile.value != null
                            ? _projectController.pdfFile.value!.path
                                .split('/')
                                .last
                            : 'Selecciona un PDF',
                      )),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _projectController.pickPDF,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => Wrap(
                        spacing: 8,
                        children: _projectController.evidenceFiles.map((file) {
                          return Chip(
                            label: Text(file.path.split('/').last),
                            deleteIcon: const Icon(Icons.close),
                            onDeleted: () {
                              _projectController.evidenceFiles.remove(file);
                            },
                          );
                        }).toList(),
                      )),
                ),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _projectController.pickEvidence,
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                labelText: 'Asignatura',
              ),
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(
                  child: Text('PROGRAMACION'),
                  value: 'PROGRAMACION',
                ),
                DropdownMenuItem(
                  child: Text('SOFTWARE'),
                  value: 'SOFTWARE',
                ),
                DropdownMenuItem(
                  child: Text('MOVIL'),
                  value: 'MOVIL',
                ),
              ],
              onChanged: (value) {
                setModalState(() {
                  _selectedSubject = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: "Subir Proyecto",
              onPressed: () {
                if (_nameController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty &&
                    _repoLinkController.text.isNotEmpty &&
                    _selectedSubject != null) {
                  _projectController.saveNewProject(
                    _nameController.text,
                    _descriptionController.text,
                    _repoLinkController.text,
                    _selectedSubject!,
                  );

                  _nameController.clear();
                  _descriptionController.clear();
                  _repoLinkController.clear();
                  setModalState(() {
                    _selectedProjectImage = null;
                    _selectedSubject = null;
                  });

                  Navigator.pop(context); // Cerrar el modal después de guardar
                } else {
                  Get.snackbar('Error', 'Por favor, completa todos los campos');
                }
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
