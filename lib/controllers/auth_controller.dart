import '../pages/login_page.dart';
import 'package:get_storage/get_storage.dart';
import '../pages/home_page.dart';
import '../services/firebase_service.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';
import 'dart:io'; // Para manejo de imágenes

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  var isLoading = false.obs; // Observa si se está cargando una operación
  var userModel = Rxn<UserModel>(); // Observa el estado del UserModel
  final storage =
      GetStorage(); // Crear una instancia de GetStorage para almacenar las credenciales

  @override
  void onInit() {
    super.onInit();
    _autoLogin(); // Intentar login automático al iniciar
  }

  // Registrar Usuario
  Future<void> register(String email, String password, String name) async {
    try {
      isLoading.value = true;
      UserModel? newUser =
          await _firebaseService.registerWithEmail(email, password, name);
      if (newUser != null) {
        userModel.value = newUser; // Usuario registrado exitosamente
        await _saveCredentials(email, password); // Guardar credenciales
        Get.offAll(() => HomePage()); // Redirigir a la vista principal
      } else {
        Get.snackbar("Error", "No se pudo registrar el usuario");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el registro");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para iniciar sesión
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      UserModel? loggedInUser =
          await _firebaseService.loginWithEmail(email, password);
      if (loggedInUser != null) {
        userModel.value = loggedInUser; // Usuario inició sesión exitosamente
        await _saveCredentials(email, password); // Guardar credenciales
        Get.offAll(() => HomePage()); // Redirigir a la vista principal
      } else {
        Get.snackbar("Error", "No se pudo iniciar sesión");
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error durante el inicio de sesión");
    } finally {
      isLoading.value = false;
    }
  }

  // Método para cerrar sesión
  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _clearCredentials(); // Eliminar credenciales guardadas
    userModel.value = null; // Usuario ha cerrado sesión
    Get.snackbar("Sesión cerrada", "Hasta pronto");
    Get.offAll(() => LoginPage()); // Redirigir a la vista de login
  }

  // Subir imagen de perfil
  Future<void> uploadProfileImage(File imageFile) async {
    if (userModel.value != null) {
      try {
        isLoading.value = true;
        String? imageUrl = await _firebaseService.uploadProfileImage(
            userModel.value!.uid, imageFile);
        if (imageUrl != null) {
          await _firebaseService.updateProfileImageUrl(
              userModel.value!.uid, imageUrl);
          userModel.value!.imageUrl =
              imageUrl; // Actualizar el modelo localmente
          Get.snackbar("Éxito", "Imagen de perfil actualizada");
        } else {
          Get.snackbar("Error", "No se pudo actualizar la imagen");
        }
      } catch (e) {
        Get.snackbar("Error", "Error al subir la imagen");
      } finally {
        isLoading.value = false;
      }
    }
  }

  // Guardar las credenciales de usuario usando GetStorage
  Future<void> _saveCredentials(String email, String password) async {
    storage.write('email', email);
    storage.write('password', password);
  }

  // Intentar login automático
  Future<void> _autoLogin() async {
    String? email = storage.read('email');
    String? password = storage.read('password');
    if (email != null && password != null) {
      await login(email, password); // Auto login con credenciales guardadas
    }
  }

  // Limpiar credenciales guardadas
  Future<void> _clearCredentials() async {
    storage.remove('email');
    storage.remove('password');
  }

  // Método para actualizar los datos del perfil del usuario
  Future<void> updateUserProfile(
      String name, String lastName, String phone) async {
    try {
      String uid = userModel.value!.uid;

      // Llamar al método del servicio para actualizar los datos en Firestore
      await _firebaseService.updateUserProfile(uid, name, lastName, phone);

      // Crear una nueva instancia de UserModel con los datos actualizados
      UserModel updatedUser = UserModel(
        uid: userModel.value!.uid,
        name: name, // Mantener el nombre actual
        lastName: lastName, // Usar el nuevo apellido
        phone: phone, // Usar el nuevo teléfono
        email: userModel.value!.email, // Mantener el correo electrónico
        imageUrl: userModel.value!.imageUrl, // Mantener la imagen de perfil
      );

      // Actualizar el estado de userModel con la nueva instancia
      userModel.value = updatedUser;
    } catch (e) {
      Get.snackbar("Error", "No se pudieron actualizar los datos del perfil");
    }
  }

// Método para actualizar la imagen de perfil
  Future<void> updateProfileImage(File imageFile) async {
    try {
      String uid = userModel.value!.uid;
      String? imageUrl =
          await _firebaseService.uploadProfileImage(uid, imageFile);

      if (imageUrl != null) {
        await _firebaseService.updateProfileImageUrl(uid, imageUrl);
        userModel.update((user) {
          user!.imageUrl = imageUrl;
        });
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar la imagen de perfil");
    }
  }
}
