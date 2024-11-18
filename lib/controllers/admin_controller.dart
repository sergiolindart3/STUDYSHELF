import 'package:get/get.dart';
import 'package:studyshelf/services/admin_service.dart';
import 'package:studyshelf/models/user_model.dart';

class AdminController extends GetxController {
  final AdminService _adminService = AdminService();
  var isLoading = false.obs; // Observa el estado de carga
  var usersList = <UserModel>[].obs; // Lista de usuarios
  var currentUserRole = ''.obs; // Rol actual del usuario

  @override
  void onInit() {
    super.onInit();
    _fetchAllUsers(); // Obtener todos los usuarios al iniciar
    _checkCurrentUserRole(); // Verificar el rol del usuario actual
  }

  // Método para verificar si el usuario es admin
  Future<void> _checkCurrentUserRole() async {
    try {
      bool isAdmin = await _adminService.isAdmin();
      currentUserRole.value = isAdmin ? 'Admin' : 'Usuario';
    } catch (e) {
      currentUserRole.value = 'Usuario';
    }
  }

  // Método para obtener todos los usuarios
  Future<void> _fetchAllUsers() async {
    try {
      isLoading.value = true;
      List<UserModel> users = await _adminService.getAllUsers();
      usersList.value = users;
    } catch (e) {
      Get.snackbar("Error", "No se pudieron obtener los usuarios.");
    } finally {
      isLoading.value = false;
    }
  }

  // Cambiar el rol de un usuario
  Future<void> changeRole(String uid, String newRole) async {
    try {
      isLoading.value = true;
      await _adminService.updateUserRole(uid, newRole);
      Get.snackbar("Éxito", "Rol actualizado exitosamente.");
      _fetchAllUsers(); // Actualizar la lista de usuarios
    } catch (e) {
      Get.snackbar("Error", "No se pudo cambiar el rol.");
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar un usuario
  Future<void> removeUser(String uid) async {
    try {
      isLoading.value = true;
      await _adminService.deleteUser(uid);
      Get.snackbar("Éxito", "Usuario eliminado correctamente.");
      _fetchAllUsers(); // Actualizar la lista de usuarios
    } catch (e) {
      Get.snackbar("Error", "No se pudo eliminar el usuario.");
    } finally {
      isLoading.value = false;
    }
  }

  String getCurrentUserUid() {
    return _adminService.getCurrentUserUid();
  }
}
