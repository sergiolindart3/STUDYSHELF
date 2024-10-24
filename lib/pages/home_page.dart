import 'package:flutter/material.dart';
import 'package:studyshelf/controllers/auth_controller.dart';
import 'package:studyshelf/pages/create_page.dart';
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
    Center(child: Text('Inicio')),
    Center(child: Text('Buscar')),
    CrearProject(),
    Center(child: Text('Notificaciones')),
    Perfil()
  ];

  // Pila para almacenar el historial de las páginas visitadas
  final List<int> _pageHistory = [];

  // Cambiar página y almacenar el índice anterior en el historial
  void _changePage(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _pageHistory.add(_selectedIndex);
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages, // Mantiene el estado de las páginas
      ),
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
        selectedItemColor: Colors.blue, // Color azul cuando está seleccionado
        unselectedItemColor:
            Colors.grey, // Color gris cuando no está seleccionado
        onTap: _changePage, // Cambiar de página al hacer tap
        showSelectedLabels: false, // Ocultar etiquetas seleccionadas
        showUnselectedLabels: false, // Ocultar etiquetas no seleccionadas
      ),
    );
  }
}
