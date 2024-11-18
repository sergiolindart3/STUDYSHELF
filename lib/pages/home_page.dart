import 'package:flutter/material.dart';
import 'package:studyshelf/controllers/auth_controller.dart';
import 'package:studyshelf/controllers/admin_controller.dart';
import 'package:studyshelf/pages/all_projects.dart';
import 'package:studyshelf/pages/create_page.dart';
import 'package:studyshelf/pages/admin_role.dart'; // Importa la página de administración
import 'package:studyshelf/pages/notify.dart';
import 'package:studyshelf/pages/profile_page.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final AuthController _authController = Get.find();
  final AdminController _adminController = Get.put(AdminController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Obx(() {
        // Verificar roles de usuario
        bool isAdmin = _adminController.currentUserRole.value == 'Admin';
        bool isTeacher = _authController.userModel.value?.role == 'Docente';

        // Páginas dinámicas
        final pages = [
          AllProjects(),
          isAdmin ? AdminRole() : CrearProject(),
          if (isTeacher) NotifyPage(), // Mostrar solo si es Docente
          Perfil(),
        ];

        // Validar índice seleccionado si cambia la longitud de las páginas
        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0; // Resetear el índice si es inválido
        }

        return IndexedStack(
          index: _selectedIndex,
          children: pages,
        );
      }),
      bottomNavigationBar: Obx(() {
        // Verificar roles de usuario
        bool isAdmin = _adminController.currentUserRole.value == 'Admin';
        bool isTeacher = _authController.userModel.value?.role == 'Docente';

        // Ítems dinámicos del BottomNavigationBar
        final items = [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(isAdmin
                ? Icons.admin_panel_settings
                : Icons.add_circle_outline),
            label: '', // Ícono dinámico
          ),
          if (isTeacher)
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '',
            ), // Mostrar solo si es Docente
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ];

        // Validar índice seleccionado si cambia la longitud de los ítems
        if (_selectedIndex >= items.length) {
          _selectedIndex = 0; // Resetear el índice si es inválido
        }

        return BottomNavigationBar(
          items: items,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
        );
      }),
    );
  }
}
