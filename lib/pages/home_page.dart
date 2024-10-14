import 'package:flutter/material.dart';
import 'package:studyshelf/controllers/auth_controller.dart';
import 'package:studyshelf/pages/home_page.dart';
import 'package:studyshelf/pages/inicio_page.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Lista de las páginas que se mostrarán en la navegación inferior
  final List<Widget> _pages = [
    InicioPage(),
    Center(child: Text('Buscar')),
    Center(child: Text('Agregar nuevo')),
    Center(child: Text('Notificaciones')),
    Perfil()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Página según la opción seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Color cuando está seleccionado
        unselectedItemColor: Colors.grey, // Color cuando no está seleccionado
        onTap: _onItemTapped, // Cambiar de página al hacer tap
        showSelectedLabels: false, // Ocultar etiquetas seleccionadas
        showUnselectedLabels: false, // Ocultar etiquetas no seleccionadas
      ),
    );
  }
}
