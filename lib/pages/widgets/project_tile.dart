import 'package:flutter/material.dart';
import 'package:studyshelf/models/project_model.dart';

class ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final bool showStatusIcon; // Nueva propiedad para mostrar/ocultar el icono

  const ProjectTile({
    Key? key,
    required this.project,
    required this.onTap,
    this.showStatusIcon = true, // Por defecto, se muestra el icono
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar si el proyecto está aceptado o pendiente
    bool isAccepted = project.isActive;

    return InkWell(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 5,
        child: ListTile(
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
          // Mostrar el ícono de estado solo si `showStatusIcon` es true
          trailing: showStatusIcon
              ? Icon(
                  isAccepted ? Icons.check_circle : Icons.pending,
                  color: isAccepted ? Colors.green : Colors.orange,
                )
              : null,
        ),
      ),
    );
  }
}
