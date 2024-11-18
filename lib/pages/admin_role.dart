import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyshelf/controllers/admin_controller.dart';
import 'package:studyshelf/pages/widgets/user_tile.dart';

class AdminRole extends StatelessWidget {
  final AdminController _adminController = Get.find();

  AdminRole({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Roles',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        // Mostrar loading mientras se cargan los usuarios
        if (_adminController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Obtener UID del usuario actual para excluirlo de la lista
        final currentUserUid = _adminController.getCurrentUserUid();

        // Filtrar lista de usuarios excluyendo al admin actual
        final filteredUsers = _adminController.usersList
            .where((user) => user.uid != currentUserUid)
            .toList();

        // Si la lista filtrada está vacía
        if (filteredUsers.isEmpty) {
          return const Center(child: Text('No hay usuarios disponibles.'));
        }

        // Mostrar la lista de usuarios usando UserTile
        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return UserTile(
              user: user,
              onChangeRole: () {
                // Mostrar opciones directamente en un menú emergente
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 50, 100),
                  items: [
                    PopupMenuItem<String>(
                      value: 'Estudiante',
                      child: const Text('Estudiante'),
                      onTap: () {
                        _adminController.changeRole(user.uid, 'Estudiante');
                      },
                    ),
                    PopupMenuItem<String>(
                      value: 'Docente',
                      child: const Text('Docente'),
                      onTap: () {
                        _adminController.changeRole(user.uid, 'Docente');
                      },
                    ),
                  ],
                );
              },
              onDeleteUser: () {
                // Mostrar advertencia antes de eliminar usuario
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Eliminar usuario'),
                      content: const Text(
                          '¿Estás seguro de que deseas eliminar este usuario?'),
                      actions: [
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            // Ejecutar la acción de eliminación y cerrar el diálogo
                            _adminController.removeUser(user.uid);
                            Navigator.of(context).pop(); // Cerrar el diálogo
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
