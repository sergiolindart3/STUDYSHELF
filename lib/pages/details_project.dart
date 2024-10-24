import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/project_model.dart';

class DetailsProject extends StatelessWidget {
  final ProjectModel project;

  const DetailsProject({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${project.projectName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (project.imgProjectUrl != null)
              Image.network(
                project.imgProjectUrl!,
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              project.projectName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Descripción: ${project.description}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Link de Repositorio: ${project.repoLink}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Asignatura: ${project.subject}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (project.pdfFile != null)
              ElevatedButton(
                onPressed: () {
                  // Lógica para abrir el PDF
                },
                child: const Text('Abrir PDF'),
              ),
            const SizedBox(height: 16),

            // Mostrar evidencias en un carrusel con autoPlay
            if (project.evidenceImages != null &&
                project.evidenceImages!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Evidencias:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      autoPlay: true, // Activa el autoPlay
                      autoPlayInterval: const Duration(
                          seconds:
                              3), // Tiempo entre cada movimiento automático
                      autoPlayAnimationDuration: const Duration(
                          milliseconds: 800), // Duración de la animación
                      autoPlayCurve:
                          Curves.fastOutSlowIn, // Tipo de curva de animación
                    ),
                    items: project.evidenceImages!.map((evidenceUrl) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                evidenceUrl,
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
