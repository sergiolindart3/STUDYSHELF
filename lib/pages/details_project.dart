import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart'; // Importa el paquete
import '../models/project_model.dart';

class DetailsProject extends StatelessWidget {
  final ProjectModel project;

  const DetailsProject({Key? key, required this.project}) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url); // Convierte el String en Uri
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Abre en una aplicación externa
      );
    } else {
      throw 'No se puede abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(project.projectName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            if (project.imgProjectUrl != null)
              Material(
                elevation: 5,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    project.imgProjectUrl!,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      );
                    },
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              project.description,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 73, 73, 73)),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            // Link de repositorio con ícono
            GestureDetector(
              onTap: () => _launchURL(project.repoLink),
              child: Row(
                children: [
                  Image.asset(
                    'assets/github.png',
                    height: 30,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Link Repositorio',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Asignatura:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(project.subject),
            const SizedBox(height: 16),
            if (project.pdfFile != null)
              GestureDetector(
                onTap: () => _launchURL(project.pdfFile!),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Fondo gris claro
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey), // Borde gris
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Centra el contenido
                    children: [
                      // Imagen del ícono PDF
                      Image.asset(
                        'assets/pdf.png', // Reemplaza con la ruta de tu imagen
                        height: 25,
                      ),
                      const SizedBox(
                          width: 8), // Espacio entre la imagen y el texto
                      // Texto "ABRIR PDF"
                      const Text(
                        'ABRIR PDF',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 101, 101, 101),
                        ),
                      ),
                    ],
                  ),
                ),
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
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              shadowColor: Colors.grey.withOpacity(0.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  evidenceUrl,
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
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
