import 'package:flutter/material.dart';
import 'package:studyshelf/models/project_model.dart';

class ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectTile({Key? key, required this.project, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        ),
      ),
    );
  }
}
